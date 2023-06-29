open PageComponents
open People
open About

type seminar = {
  date: Js.Date.t,
  title: React.element,
  abstract: React.element,
  presenter: string,
  presenter_page_url: string,
}

module Seminar = {
  @react.component
  let make = (~seminar: seminar) =>
    <li className=%twc("pl-6 pb-4")>
      <span className=%twc("italic")>
        {Js.Date.toISOString(seminar.date)->String.split("T")->Array.getUnsafe(0) ++ ":"
          |> React.string}
      </span>
      <span className=%twc("pl-2")>
        <Link.Text target=seminar.presenter_page_url> {React.string(seminar.presenter)} </Link.Text>
      </span>
      <span> {" — " |> React.string} </span>
      <span className=%twc("font-bold")> {seminar.title} </span>
      <span> {" — " |> React.string} </span>
      <span> {seminar.abstract} </span>
    </li>
}

let seminars = [
  {
    date: Js.Date.fromFloat(Js.Date.utcWithYMD(~year=2023.0, ~month=03.0, ~date=24.0, ())),
    title: <Lang.String
      english="Translating law to code at the French tax authority"
      french={`Traduire le droit en code à la DGFiP`}
    />,
    presenter: "DGFiP/SI",
    presenter_page_url: "https://metiers.numerique.gouv.fr/employeurs/service-des-systemes-d-information-de-la-direction-generale-des-finances-publiques-dgfip-cl1mbk9aj914201lpc0cdqd0s4",
    abstract: <Lang.String
      english="Each year, the civil servants of the French tax authority have to implement the legislative changes to tax law voted in the finance bill. There are \
  numerous challenges in keeping a large codebase, modelling increasingly complex tax rules, up to date and correct. In this seminar, some of them \
  come to tell their tales about their experience accumulated over several decades."
      french={`Chaque année, les fonctionnaires de l'administration fiscale française doivent mettre \
    en œuvre les modifications législatives du droit fiscal votées dans le cadre de la loi de \
    finances. Maintenir à jour et corriger une base de code importante, modélisant des règles fiscales \
    de plus en plus complexes, pose de nombreux défis. Dans ce séminaire, certains d'entre eux \
    viennent raconter leur expérience accumulée depuis plusieurs décennies.`}
    />,
  },
  {
    date: Js.Date.fromFloat(Js.Date.utcWithYMD(~year=2023.0, ~month=05.0, ~date=05.0, ())),
    title: <Lang.String
      english="Drafting Rules between Technical and Legal Expertise: the Work of French Central Administration on Health Risks"
      french={`Rédiger les normes entre expertise technique et expertise juridique : le travail des administrations centrales face aux risques sanitaires`}
    />,
    presenter: "Didier Torny",
    presenter_page_url: "https://cv.hal.science/didier-torny",
    abstract: <Lang.String
      english="The drafting of public rules is usually considered a de facto \
    prerogative of lawyers, due to their skills and expertise. They translate \
    complex realities into law, while inserting them into a pre-existing \
    legislative and regulatory apparatus. But, in France, many ministries \
    and public administrations are almost devoid of these types of personnel \
    and entrust the drafting work to non-law professionals. It is the case of \
    the public health and veterinary health administrations where Veterinary \
    Public Health Inspectors (ISPV), Medical Public Health Inspectors (MISP) \
    and Pharmacist Public Health Inspectors (PhISP) draft decrees, \
    administrative orders and government circulars (circulaires administratives). \
    The presentation on the normative drafting work articulates the issue raised \
    by now autonomous expertise structures (agencies), the general legal framework \
    for the protection of people and animals and the will to write for an \
    implementation closer to the field."
      french={`La rédaction des normes publiques est habituellement considérée \
     comme étant une prérogative de fait des professions juridiques, en raison \
      de leurs compétences et savoir-faire. Ses membres traduisent dans le \
      droit/en droit des réalités complexes, tout en les insérant dans un \
      appareil législatif et réglementaire pré-existant.  Mais de nombreux \
      ministères et administrations sont quasiment dépourvus de ces types \
      de personnel et confient le travail rédactionnel à des non \
      professionnels du droit : c'était le cas des administrations de la santé \
      publique et de la santé vétérinaire où Inspecteurs de santé publique \
      vétérinaire (ISPV), Médecins Inspecteurs de santé publique (MISP) et \
      Pharmaciens inspecteurs de santé publique (PhISP) rédigent décrets, \
      arrêtés et circulaires. À l'articulation entre des structures \
      d'expertises désormais autonomes, un cadre juridique général de \
      protection des personnes et des animaux et une volonté d'écrire pour une \
      mise en oeuvre au plus près du terrain, ce travail de rédaction normatif \
      sera au coeur de cette présentation. Elle se fondera sur les éléments \
      empiriques issus de travaux antérieurs sur l’administration sanitaire en \
      France.`}
    />,
  },
  {
    date: Js.Date.fromFloat(Js.Date.utcWithYMD(~year=2023.0, ~month=06.0, ~date=03.0, ())),
    title: <Lang.String
      english="Explaining and justifying algorithmic decision systems: theory and practice"
      french={`Expliquer et justifier des systèmes de décisions algorithmiques : théorie et pratique`}
    />,
    presenter: "Clément Hénin",
    presenter_page_url: "https://planete.inrialpes.fr/people/chenin/",
    abstract: <Lang.String
      english="In a context favorable to the rationalization of decisions \
      through measurable objectives and quantitative methods, the recent \
      development of digital technologies has accelerated the adoption of \
      decision-making systems based on algorithmic processing. Research in \
      the field of eXplainable Artififial Intelligence (XAI) aims to guarantee \
      the intelligibility of decision algorithms. In this context, we propose \
      an original method enabling users of algorithmic systems to challenge or \
      justify their decisions. A justification (respectively a challenge) is \
      an argument, supported by evidence, that a decision is right \
      (respectively wrong) in the sense of a set of predefined external \
      norms. A technical device, called Algocate, makes it possible to \
      operationalize these notions for three types of norms (rules, \
      objectives and reference) thanks to an interactive system enabling \
      the user to express his or her point of view on the merits of the \
      decision. These types of solutions (explanations and justifications) \
      are put into practice in the context of the heart score, an algorithmic \
      decision-making system used by the Biomedicine agency since 2018 to \
      allocate heart transplants throughout France."
      french={`Dans un contexte favorable à la rationalisation des décisions \
      par des objectifs mesurables et des méthodes quantitatives, le \
      développement récent des technologies numériques a accéléré l’adoption \
      des systèmes de décisions fondés sur un traitement algorithmique. Des \
      travaux de recherche du champ de l'eXplainable Artififial Intelligence \
      (XAI) visent à garantir l’intelligibilité des algorithmes de décisions. \
      Dans ce contexte, nous proposons une méthode originale permettant aux \
      utilisateurs de systèmes algorithmiques d'en contester ou d'en justifier \
      les décisions. Une justification (respectivement une contestation) est un \
      argument, soutenu par une preuve, qu’une décision est bonne (respectivement \
      mauvaise) au sens d’un ensemble de normes extérieures prédéfinies. Un \
      dispositif technique, appelé Algocate, permet de rendre ces notions \
      opérationnelles pour trois types de normes (règles, objectifs et \
      référence) grâce à un système interactif permettant à l’utilisateur \
      d’exprimer son point de vue sur le bien-fondé de la décision. Ce type de \
      solutions (explications et justifications) sont mises en pratique dans le \
      cadre du score cœur, un système algorithmique de décision utilisé par \
      l'agence de Biomédecine depuis 2018 pour attribuer les greffons cardiaques \
      sur l'ensemble du territoire.`}
    />,
  },
  {
    date: Js.Date.fromFloat(Js.Date.utcWithYMD(~year=2023.0, ~month=08.0, ~date=04.0, ())),
    title: <Lang.String english="Title to come" french={`Titre à venir`} />,
    presenter: "Sarah Lawsky",
    presenter_page_url: "https://sites.northwestern.edu/sarahlawsky/",
    abstract: <Lang.String english="Abstract to come" french={`Résumé à venir`} />,
  },
]

let upcoming = Belt.Array.keep(seminars, seminar => seminar.date >= Js.Date.make())
let past = Belt.Array.keep(seminars, seminar => seminar.date < Js.Date.make())

@react.component
let make = () => {
  <>
    <Title>
      <Lang.String english="Seminar" french={`Séminaire`} />
    </Title>
    <div className=%twc("flex flex-col justify-center items-center")>
      <p>
        <Lang.String
          english="The Catala team hosts seminars at Inria Paris one Monday per month, from 17:00 to 18:30. The seminar happens in room Gilles Kahn on the ground floor of the Inria Paris building located at 2 rue Simone Iff 75012."
          french={`L'équipe Catala organise des séminaires à l'Inria Paris un lundi par mois de 17:00 à 18:30. Le séminaire se tient dans la salle Gilles Kahn au rez-de-chaussée du bâtiment de l'Inria Paris situé au 2 rue Simone Iff 75012.`}
        />
      </p>
      <Link.Button target={"https://sympa.inria.fr/sympa/subscribe/seminaire-catala"}>
        <Lang.String
          english="Subscribe to the seminar mailing list"
          french={`S'incrire à la newsletter du séminaire`}
        />
      </Link.Button>
    </div>
    <Section title={<Lang.String english="Upcoming seminars" french={`Séminaires à venir`} />}>
      <ul className=%twc("list-disc list-inside")>
        {upcoming
        ->Belt.Array.mapWithIndex((i, item) =>
          <Seminar key={"upcoming-seminar-item-" ++ i->string_of_int} seminar=item />
        )
        ->React.array}
      </ul>
    </Section>
    <Section title={<Lang.String english="Past seminars" french={`Séminaires passés`} />}>
      <ul className=%twc("list-disc list-inside")>
        {past
        ->Belt.Array.mapWithIndex((i, item) =>
          <Seminar key={"upcoming-seminar-item-" ++ i->string_of_int} seminar=item />
        )
        ->React.array}
      </ul>
    </Section>
    <Section title={<Lang.String english="Organizers" french={`Organisateurs`} />}>
      <ul className=%twc("list-disc list-inside")>
        <Person person=marieAlauzen />
        <Person person=lianeHuttner />
        <Person person=denisMerigoux />
      </ul>
    </Section>
  </>
}
