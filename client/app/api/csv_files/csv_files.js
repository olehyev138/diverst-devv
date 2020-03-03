import API from 'api/base/base';
const axios = require('axios');

const CsvFiles = new API({ controller: 'csv_files' });

Object.assign(CsvFiles, {
});

export default CsvFiles;
