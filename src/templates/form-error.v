module templates

/*
	This is a template for a form error
	This is not in a html file because I need to reuse this in two controller functions
	So I would need to duplicate this template in two different files,
	due to vweb templating running on compile time based on the function name
*/
pub fn form_error(error string) string {
	return '<div class="alert alert-error">
    <div class="flex-1">
        <label class="mr-4 flex items-center gap-1">
            <i data-lucide="x-circle"></i>
            <span class="font-medium">Error:</span>
            <span>${error}</span>
        </label>
    </div>
</div>'
}
