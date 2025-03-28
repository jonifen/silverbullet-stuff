---
description: Display a calendar on the journal
tags: template
hooks.top:
  where: 'type = "journal"'
  order: 0
---
{{#let @journalDate = getDateFromJournalPath(@page.name)}}
{{generateSprintCalendar(@journalDate)}}
{{/let}}