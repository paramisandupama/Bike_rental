<%-- Floating Inquiry Button Component --%>
<div class="fixed bottom-6 right-6 z-50">
    <button onclick="openInquiryModal()" class="w-14 h-14 rounded-full bg-green-600 text-white shadow-lg flex items-center justify-center hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
        <i class="fas fa-question-circle text-2xl"></i>
    </button>
</div>

<%-- Inquiry Modal --%>
<div id="inquiryModal" class="fixed inset-0 z-50 hidden overflow-y-auto">
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
            <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-green-50 sm:mx-0 sm:h-10 sm:w-10">
                        <i class="fas fa-question-circle text-green-600"></i>
                    </div>
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                        <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                            Submit an Inquiry
                        </h3>
                        <div class="mt-4">
                            <form id="inquiryForm" action="<%= request.getContextPath() %>/inquiries/submit" method="post">
                                <input type="hidden" name="returnUrl" value="<%= request.getRequestURI() %>">
                                <div class="mb-4">
                                    <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">Subject</label>
                                    <input type="text" id="subject" name="subject" required
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                </div>
                                <div class="mb-4">
                                    <label for="message" class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                                    <textarea id="message" name="message" rows="4" required
                                              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"></textarea>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                <button type="submit" form="inquiryForm" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm">
                    Submit
                </button>
                <button type="button" onclick="closeInquiryModal()" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                    Cancel
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    function openInquiryModal() {
        document.getElementById('inquiryModal').classList.remove('hidden');
    }

    function closeInquiryModal() {
        document.getElementById('inquiryModal').classList.add('hidden');
    }
</script>
