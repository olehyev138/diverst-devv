function async_select(url) {
    return {
        ajax: {
            url: url,
            theme: 'bootstrap',
            allowClear: true,
            type: "GET",
            dataType: "json",
            minimumInputLength: 3,
            multiple:true,
            delay: 1000,
            data: function (params) {
                // Query parameters will be ?search=[term]&type=public
                return { search: { value: params.term } }
            },
            processResults: function (data) {
                var int = 1;

                // Tranforms the top-level key of the response object from 'items' to 'results'
                return {
                    results: $.map(data.data, function(item){
                        return {id: item[0], text: item[1] + " " + item[2] + " - " + item[3] } } )
                };
            },
            templateSelection: function(item) {
                return item[0]
            }
        }
    }
}
