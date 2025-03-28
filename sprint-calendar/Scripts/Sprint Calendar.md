```space-script
silverbullet.registerFunction("getDateFromJournalPath", async (fileName) => {
  const fileParts = fileName.split("/");
  return fileParts[fileParts.length - 1];
});

silverbullet.registerFunction("generateSprintCalendar", async (currentDate) => {
  const getCurrentSprint = async (date) => {
    const dateForDate = new Date(date);
    const uint8array = await space.readFile("/Library/Personal/Data/sprints.json");
    const sprintsString = new TextDecoder().decode(uint8array);
    const sprintsData = JSON.parse(sprintsString);

    return sprintsData.sprints.find((sprint) =>
      new Date(sprint.startDate) <= dateForDate &&
      new Date(sprint.endDate) >= dateForDate);
  };

  const currentDateObj = new Date(currentDate);
  const today = currentDateObj.getDate();
  const currentSprint = await getCurrentSprint(currentDate);

  const daysOfSprint = ["We", "Th", "Fr", "Mo", "Tu", "We", "Th", "Fr", "Mo", "Tu"];
  const date = new Date(currentSprint.startDate);

  // Create the headings
  let markdown = "# " + currentSprint.name + "\n";
  markdown += "| " + daysOfSprint.join("| ") + " |\n";
  markdown += "| " + "---|".repeat(daysOfSprint.length) + "\n";

  // Create the dates
  while (date <= new Date(currentSprint.endDate)) {
    let day = date.getDate();
    let year = date.getFullYear();
    let month = date.getMonth() + 1;

    if (![0,6].includes(date.getDay())) {
      let datePage = "work/journal/" + String(year) + "/" + String(month).padStart(2, "0") + "/" + String(year) + "-" + String(month).padStart(2, "0") + "-" + String(day).padStart(2, "0");

      let displayDay = "[[" + datePage + "|" + String(day).padStart(2, " ") + "]]";

      if (today === day) {
        markdown += "| (" + displayDay + ") ";
      } else {
        markdown += "| " + displayDay + " ";
      }
    }

    date.setDate(date.getDate() + 1);
  }
  
  return markdown;
});
```
