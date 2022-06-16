@decco.decode
type sourcePosition = {
  fileName: string,
  startLine: int,
  endLine: int,
  startColumn: int,
  endColumn: int,
  lawHeadings: array<string>,
}

module rec LoggedValue: {
  @decco.decode
  type rec t =
    | Unit
    | Bool(bool)
    | Integer(int)
    | Money(float)
    | Decimal(float)
    | Date(string)
    | Duration(string)
    | Enum(list<string>, (string, t))
    | Struct(list<string>, list<(string, t)>)
    | Array(array<t>)
    | Unembeddable

  let loggedValueToString: (t, int) => string

  @react.component
  let make: (~depth: int=?, ~val: t) => React.element
} = {
  @decco.decode
  type rec t =
    | Unit
    | Bool(bool)
    | Integer(int)
    | Money(float)
    | Decimal(float)
    | Date(string)
    | Duration(string)
    | Enum(list<string>, (string, t))
    | Struct(list<string>, list<(string, t)>)
    | Array(array<t>)
    | Unembeddable

  let rec loggedValueToString = (val: t, tab: int) => {
    Js.String.repeat(tab, "\t") ++
    switch val {
    | Unit => "Unit"
    | Bool(b) => "Bool: " ++ string_of_bool(b)
    | Money(f) => "Money: " ++ Js.Float.toString(f)
    | Integer(i) => "Integer: " ++ string_of_int(i)
    | Decimal(f) => "Decimal: " ++ Js.Float.toString(f)
    | Date(d) => "Date: " ++ d
    | Duration(d) => "Duration: " ++ d
    | Enum(ls, (s, vals)) =>
      "Enum[" ++ String.concat(",", ls) ++ "]:" ++ s ++ "\n" ++ vals->loggedValueToString(tab + 1)
    | _ => "Other"
    }
  }

  @react.component
  let make = (~depth=1, ~val: t) => {
    <>
      {switch val {
      | Unit => <CatalaCode.Span kind="nc" code={"()"} />
      | Bool(b) => <CatalaCode.Span kind="mb" code={b->string_of_bool} />
      | Integer(i) => <CatalaCode.Span kind="mi" code={i->string_of_int} />
      | Money(m) => <>
          <CatalaCode.Span kind="mf" code={m->Js.Float.toString} /> <CatalaCode.Op op={` €`} />
        </>
      | Decimal(d) => <CatalaCode.Span kind="mf" code={d->Js.Float.toString} />
      | Date(d) => <CatalaCode.Span kind="mi" code=d />
      | Duration(d) => <CatalaCode.Span kind="mi" code=d />
      | Enum(_ls, (s, Unit)) => <> <CatalaCode.Ids ids={[s]} /> </>

      | Enum(ls, (s, val)) => <>
          <CatalaCode.Op op={Js.String.repeat(depth * 2, " ")} />
          <CatalaCode.Ids ids={ls->Belt.List.toArray} />
          <CatalaCode.Op op=" = " />
          <CatalaCode.Ids ids={[s]} />
          <LoggedValue depth={depth + 1} val />
        </>
      | Struct(ls, attributes) => <>
          <CatalaCode.Ids ids={ls->Belt.List.toArray} />
          <CatalaCode.Op op=" = {" />
          <br />
          {attributes
          ->Belt.List.toArray
          ->Belt.Array.map(attribute => {
            let (id, val) = attribute
            <>
              <CatalaCode.Op op={Js.String.repeat(depth * 2, " ")} />
              <CatalaCode.Op op=" -- " />
              <CatalaCode.Ids ids={[id]} />
              <CatalaCode.Op op=" = " />
              <LoggedValue depth={depth + 1} val />
              <CatalaCode.Op op=", " />
              <br />
            </>
          })
          ->React.array}
          <br />
          <CatalaCode.Op op={Js.String.repeat((depth - 1) * 2, " ")} />
          <CatalaCode.Op op="}" />
        </>
      | Array(vals) => <>
          <CatalaCode.Op op="[" />
          <br />
          {vals
          ->Belt.Array.map(val => <>
            <CatalaCode.Op op={Js.String.repeat(depth * 2, " ")} />
            <LoggedValue depth={depth + 1} val />
            <CatalaCode.Op op="," />
            <br />
          </>)
          ->React.array}
          <CatalaCode.Op op="]" />
        </>
      | Unembeddable => <> {"Unembeddable"->React.string} </>
      }}
    </>
  }
}

@ocaml.doc("The logging is constituted of two phases:

    - The first one consists of collecting {i raw} events (see
      {!type:raw_event}) during the program execution (see {!val:retrieve_log})
      throught {!instruments}.
    - The second one consists in parsing the collected raw events into
      {i structured} ones (see {!type: event}).")
module Raw = {
  type eventSerialized = {
    eventType: string,
    information: array<string>,
    sourcePosition: Js.Nullable.t<sourcePosition>,
    loggedValueJson: string,
  }

  type eventType =
    | BeginCall
    | EndCall
    | VariableDefinition
    | DecisionTaken

  type event = {
    eventType: eventType,
    information: array<string>,
    sourcePosition: option<sourcePosition>,
    loggedValue: LoggedValue.t,
  }

  let eventTypeFromString = (str: string): eventType => {
    switch str {
    | "Begin call" => BeginCall
    | "End call" => EndCall
    | "Variable definition" => VariableDefinition
    | "Decision taken" => DecisionTaken
    | _ =>
      // NOTE: find a better way to handle errors?
      Js.Exn.raiseError(`Unknown event type: ${str}`)
    }
  }

  let deserializedEvents = (rawEventsSerialized: array<eventSerialized>) => {
    rawEventsSerialized->Belt.Array.map((rawEventSerialized: eventSerialized) => {
      let loggedValue = try {
        switch LoggedValue.t_decode(Js.Json.parseExn(rawEventSerialized.loggedValueJson)) {
        | Ok(val) => val
        | Error(_decodeError) => LoggedValue.Unembeddable
        }
      } catch {
      | Js.Exn.Error(obj) =>
        switch Js.Exn.message(obj) {
        | Some(m) =>
          Js.log("Caught a JS exception! Message: " ++ m)
          LoggedValue.Unembeddable
        | None => LoggedValue.Unembeddable
        }
      }
      {
        eventType: rawEventSerialized.eventType->eventTypeFromString,
        information: rawEventSerialized.information,
        sourcePosition: rawEventSerialized.sourcePosition->Js.Nullable.toOption,
        loggedValue: loggedValue,
      }
    })
  }
}

type eventSerialized = {data: string}

@decco.decode
type information = list<string>

@decco.decode
type rec event =
  | VarComputation(var_def)
  | FunCall(fun_call)
  | SubScopeCall(sub_scope_call)
@decco.decode
and var_def = {
  pos: option<sourcePosition>,
  name: information,
  value: LoggedValue.t,
  fun_calls: option<list<fun_call>>,
}
@decco.decode
and fun_call = {
  fun_name: information,
  input: var_def,
  body: list<event>,
  ouput: var_def,
}
@decco.decode
and sub_scope_call = {
  @decco.key("name") sname: information,
  inputs: list<var_def>,
  @decco.key("body") sbody: list<event>,
}

let deserializedEvents = (rawEventsSerialized: array<eventSerialized>) => {
  rawEventsSerialized->Belt.Array.map((rawEventSerialized: eventSerialized) => {
    let data = rawEventSerialized.data
    let event = try {
      switch event_decode(Js.Json.parseExn(data)) {
      | Ok(val) => val
      | Error(_decodeError) => Js.Exn.raiseError("TODO: handle error")
      }
    } catch {
    | Js.Exn.Error(_) => Js.Exn.raiseError("TODO: handle error")
    }
    event
  })
}
