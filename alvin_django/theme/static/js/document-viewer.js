document.addEventListener('alpine:init', () => {
    Alpine.data('documentViewer', () => ({
        sidebarOpen: false,
        docOpen: false,
        isFirstLoad: true,
        currentBlobUrl: null,
        currentPage: 1,
        totalPages: 0,
        
        selectedCategory: '',

        toggleSidebar() {
        this.sidebarOpen = !this.sidebarOpen;
        if (this.sidebarOpen) {
            setTimeout(() => {
            const activeThumb = document.querySelector('.thumb-item.border-orange-500');
            if (activeThumb) activeThumb.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }, 300);
        }
        },

        goToPage(page) {
        let p = parseInt(page);
        if (isNaN(p) || p < 1) p = 1;
        if (p > this.totalPages) p = this.totalPages;
        
        if (window.osdViewer) window.osdViewer.goToPage(p - 1);
        },
        prevPage() {
        if (this.currentPage > 1) this.goToPage(this.currentPage - 1);
        },
        nextPage() {
        if (this.currentPage < this.totalPages) this.goToPage(this.currentPage + 1);
        },

        toggleFullscreen() {
        const container = document.getElementById('viewer-fullscreen-container');
        if (!document.fullscreenElement) {
            container.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
        },

        async toggleDoc() {
            this.docOpen = !this.docOpen;

            if (this.docOpen && this.isFirstLoad) {
                await this.$nextTick(); 
                
                this.loadCurrentCategoryFile();
                this.isFirstLoad = false;
            }
        },

        loadCurrentCategoryFile() {
        const selector = document.getElementById('file-select-' + this.selectedCategory);
        if (selector && selector.options.length > 0) {
            const option = selector.options[selector.selectedIndex];
            this.renderDoc(option.value, option.dataset.mime);
        }
        },

        categoryChanged() {
        this.$nextTick(() => {
            const selector = document.getElementById('file-select-' + this.selectedCategory);
            if (selector && selector.options.length > 0) {
            selector.selectedIndex = 0;
            }
            this.loadCurrentCategoryFile();
        });
        },

        async renderDoc(url, mimeType = 'application/pdf') {
            const wrapper = document.getElementById('pdf-iframe-wrapper');
            wrapper.innerHTML = `
                <div class="absolute inset-0 flex items-center justify-center">
                    <svg class="animate-spin size-10 text-dark-alvin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                </div>
            `;

        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            if (mimeType === 'text/plain') {
            const textContent = await response.text();
            wrapper.innerHTML = '';
            
            const pre = document.createElement('pre');
            pre.className = "absolute inset-0 w-full h-full p-4 overflow-auto font-mono text-sm whitespace-pre-wrap text-black bg-white dark:bg-gray-900 dark:text-gray-200";
            pre.textContent = textContent;
            
            wrapper.appendChild(pre);
            return; 
            }
            
            const blob = await response.blob();
            const fileBlob = new Blob([blob], { type: mimeType });
            
            if (this.currentBlobUrl) URL.revokeObjectURL(this.currentBlobUrl);
            this.currentBlobUrl = URL.createObjectURL(fileBlob);
            
            const fileObject = document.createElement("object");
            fileObject.data = this.currentBlobUrl + "#view=FitH";
            fileObject.type = mimeType;
            fileObject.className = "absolute inset-0 w-full h-full border-0 block bg-transparent";
            
            wrapper.innerHTML = ''; 
            wrapper.appendChild(fileObject);
            
        } catch (error) {
            wrapper.innerHTML = `<div class="absolute inset-0 flex flex-col items-center justify-center text-center">
                <p class="mb-2">{% translate 'Kunde inte ladda dokumentet direkt i webbläsaren'%}.</p>
                <a href="${url}" download class="flex flex-row gap-x-1 items-center px-5 py-2 bg-gray-100 border border-[#D1D9D5] rounded-md cursor-pointer text-center hover:bg-gray-300 shadow-sm transition ease-in-out duration-150">
                <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
                    <title>{% translate 'Ladda ned' %}</title>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3" />
                </svg>
                <span>{% translate 'Ladda ned' %}</span>
                </a>
            </div>`;
        }
        },
        
        cleanup() {
        if (this.currentBlobUrl) URL.revokeObjectURL(this.currentBlobUrl);
        },

        osdZoomIn() {
        if (window.osdViewer && window.osdViewer.viewport) window.osdViewer.viewport.zoomBy(1.2);
        },
        osdZoomOut() {
        if (window.osdViewer && window.osdViewer.viewport) window.osdViewer.viewport.zoomBy(0.8);
        },
        osdHome() {
        if (window.osdViewer && window.osdViewer.viewport) window.osdViewer.viewport.goHome();
        },
        osdRotateLeft() {
        if (window.osdViewer && window.osdViewer.viewport) {
            const currentRot = window.osdViewer.viewport.getRotation();
            window.osdViewer.viewport.setRotation(currentRot - 90);
        }
        },
        osdRotateRight() {
        if (window.osdViewer && window.osdViewer.viewport) {
            const currentRot = window.osdViewer.viewport.getRotation();
            window.osdViewer.viewport.setRotation(currentRot + 90);
        }
        }
    }))
})
