```space-script
silverbullet.registerFunction({name: "generateSprintCalendar"}, async (currentDate) => {

  const today = new Date(currentDate).getDate();
  
  // realToday is actually today, not current date "today"
  const realToday = new Date();

  const getCurrentSprint = async (date) => {
    const dateForDate = new Date(date);
    const uint8array = await space.readFile("Library/Data/sprints.json");
    var sprintsString = new TextDecoder().decode(uint8array);
    var sprintsData = JSON.parse(sprintsString);

    const activeSprint = sprintsData.sprints.find(s => new Date(s.startDate) <= dateForDate && new Date(s.endDate) >= dateForDate);

    return activeSprint;
  };
  
  const buildJournalLink = (date, textOverride, skipFormatting) => {
    const day = date.getDate();
    const year = date.getFullYear();
    const month = date.getMonth() + 1;

    const datePath = "work/journal/" + String(year) + "/" + String(month).padStart(2, '0') + "/" + String(year) + "-" + String(month).padStart(2, '0') + "-" + String(day).padStart(2, '0');

    const textToDisplay = !textOverride ? String(day) : textOverride;

    let journalLink = "[[" + datePath + "|" + textToDisplay + "]]";

    if (!skipFormatting) {
      if (realToday.getDate() === day && realToday.getMonth() + 1 === month && realToday.getFullYear() === year)
        journalLink = "**" + journalLink + "**";

      if (today === day)
        journalLink = "(" + journalLink + ")";
    }

    return "| " + journalLink + " ";
  };

  const currentSprint = await getCurrentSprint(currentDate);

  const monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
  const daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  const daysOfSprint = ["<", "We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu", ">"];
  const date = new Date(currentSprint.startDate);

  const lastDayOfPreviousSprint = new Date(currentSprint.startDate);
  lastDayOfPreviousSprint.setDate(lastDayOfPreviousSprint.getDate() - 1);

  const firstDayOfNextSprint = new Date(currentSprint.endDate);
  firstDayOfNextSprint.setDate(firstDayOfNextSprint.getDate() + 1);

  // Create headers
  let markdown = "# " +  currentDate + " - " + currentSprint.name + " " + buildJournalLink(new Date(), "today", true) + "\n";
  markdown += '| ' + daysOfSprint.join(' | ') + ' |\n';
  markdown += '| ' + '--- |'.repeat(daysOfSprint.length) + '\n';

  markdown += buildJournalLink(lastDayOfPreviousSprint, "<");
  
  // Create dates
  while (date <= new Date(currentSprint.endDate)) {
    if (![0, 6].includes(date.getDay())) {
      markdown += buildJournalLink(date);
    }
    date.setDate(date.getDate() + 1);
  }

  markdown += buildJournalLink(firstDayOfNextSprint, ">");

  return markdown;
});
```
