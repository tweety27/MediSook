const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const connection = mysql.createConnection({
  host: 'my-db.cdb32svplxdn.ap-northeast-2.rds.amazonaws.com',
  port: 3306,
  user: 'admin',
  password: 'grad2023',
  database: 'schema_name',
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL: ', err);
    throw err;
  }
  console.log('Connected to MySQL');
});

app.get('/search/:itemName', (req, res) => {
  const searchTerm = req.params.itemName;
  const sql = 'SELECT * FROM medinfo WHERE itemName LIKE ?';
  const params = [`%${searchTerm}%`];

  connection.query(sql, params, (err, rows) => {
    if (err) {
      console.error('Error executing query: ', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.json(rows);
    }
  });
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});