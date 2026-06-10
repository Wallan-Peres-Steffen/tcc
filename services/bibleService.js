const fs = require("fs");
const path = require("path");

const bibliaPath = path.join(__dirname, "../data/biblia.json");

const biblia = JSON.parse(
  fs.readFileSync(bibliaPath, "utf8")
);

module.exports = biblia;