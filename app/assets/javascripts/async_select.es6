const async_select_objects = {
    USERS: 'users',
    FOLDERS: 'folders',
};

function async_select(url, object, options: {}) {
    return {
        ajax: {
            url: url,
            theme: 'bootstrap',
            allowClear: true,
            type: 'GET',
            dataType: 'json',
            minimumInputLength: 3,
            multiple:true,
            delay: 1000,
            data: function (params) {
                // Query parameters will be ?search=[term]&type=public
                return { search: { value: params.term } }
            },
            processResults: function (data) {
                // Transforms the data into a 'select' format
                // ie: For each item, a id and a string representation

                switch (object) {
                    case async_select_objects.USERS:
                        return process_user_results(data, options)
                        break;
                    case async_select_objects.FOLDERS:
                        return process_folder_results(data, options)
                        break;
                }
            },
            templateSelection: function(item) {
                return item[0]
            }
        }
    }
}

function process_user_results(data, options) {
    return {
        results: $.map(data.data, function(item) {
            return { id: item[0], text: item[1] + ' ' + item[2] + ' - ' + item[3] } } )
    };
}

function process_folder_results(data, options) {
    data =  {
        results: $.map(data, function(item) {
            return { id: item['id'], text: item['name'] } } )
    }

    // Remove current folder from results
    data.results = data.results.filter(item => item.id != options.current_folder_id);

    return data;
}