function importEpiCollect() {
  // Your EpiCollect CSV export link
  var url = "https://five.epicollect.net/api/export/entries/garden-phenology?format=csv";
  
  // Target sheet
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sheet1");
  
  // Fetch CSV data
  var response = UrlFetchApp.fetch(url);
  var csvData = Utilities.parseCsv(response.getContentText());
  
  if (!csvData || csvData.length === 0) {
    Logger.log("No data found from EpiCollect.");
    return;
  }

  // ---- MAP ORIGINAL HEADERS TO CLEAN NAMES ----
  var headerMap = {
    "1_What_is_the_date": "date",
    "2_Which_plot_are_you": "plot",
    "3_What_species_isare": "species_common",
    "4_Observer": "observer",
    "5_Comments": "comments"
  };

  // Clean headers
  var headers = csvData[0].map(name => headerMap[name] || name);
  var speciesColIndex = headers.indexOf("species_common");
  if (speciesColIndex === -1) {
    throw new Error("Column 'species_common' not found in CSV headers.");
  }

  // ---- EXPAND ROWS BASED ON SPECIES LIST ----
  var expandedData = [headers]; // keep headers as first row

  for (var i = 1; i < csvData.length; i++) {
    var row = csvData[i];
    var speciesCell = row[speciesColIndex];
    
    if (!speciesCell) continue; // skip empty
    
    // Split species by comma, semicolon, or slash
    var speciesList = speciesCell
      .split(/[,;/]+/)
      .map(s => s.trim())
      .filter(Boolean); // remove empty entries

    // Create one row per species
    speciesList.forEach(species => {
      var newRow = row.slice(); // copy original
      newRow[speciesColIndex] = species; // replace species cell
      expandedData.push(newRow);
    });
  }

  // ---- WRITE TO SHEET ----
  sheet.clearContents();
  sheet.getRange(1, 1).setValue("Last updated: " + new Date());

  // Write data starting from row 2
  sheet.getRange(2, 1, expandedData.length, expandedData[0].length).setValues(expandedData);
}
