#import "@preview/scienceicons:0.1.0": orcid-icon

#let resume(
  author: "",
  author-position: left,
  personal-info-position: left,
  pronouns: "",
  location: "",
  email: "",
  github: "",
  linkedin: "",
  phone: "",
  personal-site: "",
  orcid: "",
  accent-color: "#000000",
  font: "New Computer Modern",
  paper: "us-letter",
  author-font-size: 20pt,
  font-size: 10pt,
  lang: "en",
  margin: 0.5in, // Reccomended to have 0.5in margin on all sides
  body,
) = {
  // Sets document metadata
  set document(author: author, title: author)

  // Document-wide formatting, including font and margins
  set text(
    // LaTeX style font
    font: font,
    size: font-size,
    lang: lang,
    // Disable ligatures so ATS systems do not get confused when parsing fonts.
    ligatures: false,
  )

  set page(
    margin: margin,
    paper: paper,
  )

  // Link styles
  show link: it => {
    if it.body == none {
      underline(it)
    } else {
      it
    }
  }

  // Small caps for section titles
  show heading.where(level: 2): it => [
    #pad(top: 0pt, bottom: -10pt, [#smallcaps(it.body)])
    #line(length: 100%, stroke: 1pt)
  ]

  // Accent Color Styling
  show heading: set text(
    fill: rgb(accent-color),
  )

  show link: set text(
    fill: rgb(accent-color),
  )

  // Name will be aligned left, bold and big
  show heading.where(level: 1): it => [
    #set align(author-position)
    #set text(
      weight: 700,
      size: author-font-size,
    )
    #pad(it.body)
  ]

  // Level 1 Heading
  [= #(author)]

  // Personal Info Helper
  let contact-item(value, prefix: "", link-type: "") = {
    if value != "" {
      if link-type != "" {
        link(link-type + value)[#(prefix + value)]
      } else {
        value
      }
    }
  }

  // Personal Info
  pad(
    top: 0.25em,
    align(personal-info-position)[
      #show link: underline
      #{
        let items = (
          contact-item(pronouns),
          contact-item(phone, link-type: "tel:"),
          contact-item(location),
          contact-item(email, link-type: "mailto:"),
          contact-item(github, link-type: "https://"),
          contact-item(linkedin, link-type: "https://"),
          contact-item(personal-site, link-type: "https://"),
          contact-item(
            orcid,
            prefix: [#orcid-icon(color: rgb("#AECD54"))orcid.org/],
            link-type: "https://orcid.org/",
          ),
        )
        items.filter(x => x != none).join("  |  ")
      }
    ],
  )

  // Main body.
  set par(justify: true)

  body
}

// Generic two by two component for resume
#let generic-two-by-two(
  top-left: "",
  top-right: "",
  bottom-left: "",
  bottom-right: "",
) = {
  [
    #top-left #h(1fr) #top-right \
    #bottom-left #h(1fr) #bottom-right
  ]
}

// Generic one by two component for resume
#let generic-one-by-two(
  left: "",
  right: "",
) = {
  [
    #left #h(1fr) #right
  ]
}

// Cannot just use normal --- ligature because ligatures are disabled for good reasons
#let date-range(
  start-date: "",
  end-date: "",
) = {
  if start-date == "" {
    end-date
  } else {
    start-date + " " + sym.dash.em + " " + end-date
  }
}

#let url-link(url) = {
  link(url)[#underline(url.replace(regex("^https?://")))]
}

// Section components below
#let edu(
  institution: "",
  dates: "",
  degree: "",
  gpa: "",
  location: "",
  // Makes dates on upper right like rest of components
  consistent: false,
) = {
  if consistent {
    // edu-constant style (dates top-right, location bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: dates,
      bottom-left: emph(degree),
      bottom-right: emph(location),
    )
  } else {
    // original edu style (location top-right, dates bottom-right)
    generic-two-by-two(
      top-left: strong(institution),
      top-right: location,
      bottom-left: emph(degree),
      bottom-right: emph(dates),
    )
  }
}

#let work(
  title: "",
  dates: "",
  company: "",
  location: "",
) = {
  generic-two-by-two(
    top-left: strong(title),
    top-right: dates,
    bottom-left: company,
    bottom-right: emph(location),
  )
}

#let project(
  role: "",
  name: "",
  url: "",
  technologies: (),
  dates: "",
  show-url: false,
) = {
  generic-one-by-two(
    left: [
      #if not show-url and url != "" {
        link(url)[#strong(name)]
      } else {
        strong(name)
      }
      #if role != "" [ #sym.dash.em #role]
      #if technologies.len() > 0 [ | #technologies.join([ #sym.dot.op ]) ]
      #if (
        show-url and url != "" and dates != ""
      ) [(#url-link(url)]
    ],
    right: {
      if dates != "" {
        dates
      } else if show-url and url != "" {
        url-link(url)
      }
    },
  )
}

#let certificate(
  name: "",
  issuer: "",
  url: "",
  date: "",
  show-url: false,
) = {
  [
    #if not show-url and url != "" {
      link(url)[#strong(name)]
    } else {
      strong(name)
    }
    #if issuer != "" [, #issuer]
    #if show-url and url != "" [(#url-link(url))]
    #h(1fr) #date
  ]
}

#let extracurricular(
  activity: "",
  role: "",
  dates: "",
) = {
  generic-one-by-two(
    left: {
      if role == "" {
        [*#activity*]
      } else {
        [*#activity* #sym.dash.em #role]
      }
    },
    right: dates,
  )
}

#let award(
  name: "",
  date: "",
) = {
  generic-one-by-two(
    left: strong(name),
    right: date,
  )
}
