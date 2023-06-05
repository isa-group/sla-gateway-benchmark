var fs = require('fs');
var jsyaml = require('js-yaml');
var express = require("express");
var app = express();

var port = 8989;
var endpoint = "/array-of-slas";

app.listen(port, function() {
    console.log(`Ready at localhost:${port}${endpoint}`);
});

app.get(endpoint, function(req, res) {
    var slas = [];
    var slaPaths = ["../specs/slas/basic1.yaml",
        "../specs/slas/basic2.yaml",
        "../specs/slas/pro3.yaml",
        "../specs/slas/pro4.yaml"
    ];
    slaPaths.forEach(function(item) {
        slas.push(jsyaml.load(fs.readFileSync(item)));
    });
    res.send(slas);
});