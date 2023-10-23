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
            <svg
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
                class="lucide lucide-x-circle"
            >
                <circle cx="12" cy="12" r="10" />
                <path d="m15 9-6 6" />
                <path d="m9 9 6 6" />
            </svg>
            <span class="font-medium">Error:</span>
            <span>${error}</span>
        </label>
    </div>
</div>'
}
