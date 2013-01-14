(function(jQuery) {
    /*
     * Set the CSRF token for each AJAX request, Rack::Csrf handle the rest.
     * Assumes your layout has a metatag with name of "_csrf" and you're
     * using the default Rack:Csrf header setup.
     */
    jQuery.ajaxSetup({
        beforeSend: function(xhr) {
            var token = jQuery('meta[name="_csrf"]').attr('content');
            xhr.setRequestHeader('X_CSRF_TOKEN', token);
        }
    });
}(jQuery));