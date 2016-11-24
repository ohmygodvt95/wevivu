app.factory('Data', function () {
    var data = {
        data: null
    };

    return {
        getData: function () {
            return data.data;
        },
        setData: function (dt) {
            data.data = dt;
            // console.log("dt", dt)
        }
    };
});