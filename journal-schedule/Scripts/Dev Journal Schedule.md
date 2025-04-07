```space-script
silverbullet.registerFunction({name: "generateDevJournalSchedule"}, async (currentDate) => {
  const today = new Date(currentDate);

  const getScheduleForDay = async (day) => {
    const uint8array = await space.readFile("Library/Data/schedule.json");
    var fileContents = new TextDecoder().decode(uint8array);
    console.log(fileContents);
    var scheduleData = JSON.parse(fileContents);

    const schedule = scheduleData[day];

    return schedule;
  };

  const schedule = await getScheduleForDay(String(today.getDay()));

  if (!schedule) return "Cannot find schedule for specified date (" + currentDate + ").";

  // Create headers
  let markdown = "## Schedule\n";
  markdown += "| Time | Description |\n";
  markdown += "| - | - |\n";

  const meetingsMarkdown = schedule.meetings.map((meeting) => {
    return "| " + meeting.start + "-" + meeting.end + " | " + meeting.name + " |";
  });

  markdown += meetingsMarkdown.join("\n");

  return markdown;
});
```