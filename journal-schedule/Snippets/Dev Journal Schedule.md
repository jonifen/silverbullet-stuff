---
tags: template
description: Generates a journal schedule based on the current day
hooks.snippet.slashCommand: journal-schedule
---
```template
{{#let @journalDate = getDateFromJournalPath(@page.name)}}
{{generateDevJournalSchedule(@journalDate)}}
{{/let}}
```
