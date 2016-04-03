module.exports = function(app, bodyparser){
    console.log("Starting express API server");
    app.use(bodyparser());
    app.use(bodyparser.urlencoded({
        extended: true
    }));
    app.listen(6000);
};
