const STARTING_PAGE = 1;
const LIMIT = 8;
const MULTISELECT_DEFAULT = false;

const CLASSES = {
    CONTENT: 'groups-content',
    HEADER: 'modal-header',
    PARENT_GROUP: 'parent',
    CHILD_GROUP: 'child',
    COLLAPSE_CONTAINER: 'collapse-container',
    GROUP_CONTAINER_PREFIX: 'group_container_',
    GROUP_PREFIX: 'group_',
    EXPAND_BUTTON: 'expand-group-btn',
    SAVE_BUTTON: 'save-groups-btn'
}
const TITLE = {
    MULTISELECT: 'Choose group(s)',
    SINGLESELECT: 'Choose group'
}

class GroupSelector {
    constructor($element) {
        // $element is the actual jQuery object representing this instance of a group selector
        this.$element = $element;
        // multiselect is a boolean that defines whether multiple groups can be selected
        this.multiselect = this.$element.data('multiselect');

        // dataUrl is the URL that the group selector fetches from
        this.dataUrl = this.$element.data('url');
        // groupsElement is the jQuery object where group data will be inserted
        this.groupsElement = $("." + CLASSES.CONTENT, this.$element);
        // store the data on the object so we can use it when expanding, etc.
        this.data = {};
        // stores the currently selected groups
        this.selectedGroupIds = [];

        this.currentPage = STARTING_PAGE;
        this.totalPages = this.currentPage;

        this.buildModalHtml();

        // Store instance in self, so that we can use access instance inside closures and event handlers
        let self = this;

        // Add event listeners
        $("." + CLASSES.SAVE_BUTTON, this.$element).each(function() {
            $(this).on('click', null, { self: self, button: this }, self.saveHandler);
        });

        this.updateData();
    }

    updateData(page = STARTING_PAGE, limit = LIMIT) {
        let self = this;

        $.get(this.dataUrl, { page: page, limit: limit }, (data) => {
            console.log(data);
            self.totalPages = data.total_pages;
            self.data = data.groups;
            self.onDataUpdate();
        });
    }

    onDataUpdate() {
        let self = this;
        let data = this.data;

        // Ugly html building

        self.groupsElement.html('');

        if (data == undefined || data.length == 0) {
            self.groupsElement.append(`
                <div class="card__section"><h4>There are no groups.</h4></div>
            `);
            return;
        }

        $.each(data, function(index, group) {
            var expandButtonHtml = "";
            var groupLogoHtml = "";

            if (group.children.length > 0) {
                expandButtonHtml = `
                    <div class="col pull-right">
                        <input type="button" value="+" class="${CLASSES.EXPAND_BUTTON} btn btn--tertiary btn--small" data-group-id="${group.id}" />
                    </div>
                `;
            }

            if (group.logo_expiring_thumb) {
                groupLogoHtml = `
                    <div class="col group-logo-container">
                        <img src="${group.logo_expiring_thumb}" alt="${group.name} Logo" width="48px" height="48px">
                    </div>
                `;
            }

            var html = `
                <div class="${CLASSES.PARENT_GROUP} card__section card__section--border ${CLASSES.GROUP_CONTAINER_PREFIX}${group.id}" data-group-id="${group.id}">
                    <div class="row">
                        ${groupLogoHtml}
                        <div class="col">
                            <label class="control">
                                <input value="0" type="hidden" class="${CLASSES.GROUP_PREFIX}${group.id}" name="${CLASSES.GROUP_PREFIX}${group.id}">
                                <input type="checkbox" class="control__input boolean optional ${CLASSES.GROUP_PREFIX}${group.id}" name="${CLASSES.GROUP_PREFIX}${group.id}">
                                <span class="control__indicator control__indicator--checkbox"></span>
                            </label>
                        </div>
                        <div class="col">
                            ${group.name}
                        </div>
                        ${expandButtonHtml}
                    </div>
                </div>
            `;

            $.each(group.children, function (cIndex, child) {
                if (child.logo_file_name && false) {
                    groupLogoHtml = `
                        <div class="col">
                            <img src="${child.logo_file_name}" alt="${child.name} Logo">
                        </div>
                    `;
                }
                else {
                    groupLogoHtml = "";
                }

                html += `
                    <div class="${CLASSES.COLLAPSE_CONTAINER} collapse card__section--border">
                        <div class="${CLASSES.CHILD_GROUP} card__section group_container_${child.id}">
                            <div class="row">
                                <div class="col">
                                    <hr class="child-indicator">
                                </div>
                                ${groupLogoHtml}
                                <div class="col">
                                    <label class="control">
                                        <input value="0" type="hidden" class="${CLASSES.GROUP_PREFIX}${child.id}" name="${CLASSES.GROUP_PREFIX}${child.id}">
                                        <input type="checkbox" class="control__input boolean optional ${CLASSES.GROUP_PREFIX}${child.id}" name="${CLASSES.GROUP_PREFIX}${child.id}">
                                        <span class="control__indicator control__indicator--checkbox"></span>
                                    </label>
                                </div>
                                <div class="col">
                                    ${child.name}
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            });

            self.groupsElement.append(html);
        });

        self.addEventListeners();
    }

    buildModalHtml() {
        let self = this;

        // Build & add modal title
        var title = "";
        if (this.multiselect === true)
            title = TITLE.MULTISELECT;
        else if (this.multiselect === false)
            title = TITLE.SINGLESELECT;
        else {
            this.multiselect = MULTISELECT_DEFAULT;
            title = MULTISELECT_DEFAULT ? TITLE.MULTISELECT : TITLE.SINGLESELECT;
        }

        $("." + CLASSES.HEADER, self.$element).append(`
            <h4 class="modal-title">${title}</h4>
        `);

        // Build & add helper elements (if necessary)
        var helperHtml = "";

        if (self.multiselect === true) {
            helperHtml += `
                <div class="col">
                    <button type="button" class="btn btn--tertiary btn--small">Select All</button>
                </div>
                <div class="col">
                    <button type="button" class="btn btn--tertiary btn--small">Clear</button>
                </div>
            `;
        }

        $(".modal-footer > .row", self.$element).append(helperHtml);
    }

    addEventListeners() {
        let self = this;

        // Add event listener for the expand buttons
        $("." + CLASSES.EXPAND_BUTTON, this.$element).each(function() {
            $(this).on('click', null, { self: self, button: this }, self.expandGroupHandler);

            // Enable expand/collapse button when expand/collapse is complete
            var button = this;
            $(button).closest("." + CLASSES.PARENT_GROUP).siblings("." + CLASSES.COLLAPSE_CONTAINER).on('shown.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });

            $(button).closest("." + CLASSES.PARENT_GROUP).siblings("." + CLASSES.COLLAPSE_CONTAINER).on('hidden.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });
        });

        // Enable the group checkbox if the row is clicked
        $("." + CLASSES.PARENT_GROUP + ", ." + CLASSES.CHILD_GROUP, this.$element).click(function (e) {
            let checkbox = $(this).find(".boolean");
            if ($(e.target).hasClass(CLASSES.EXPAND_BUTTON))
                return;
            checkbox.prop("checked", !checkbox.prop("checked"));
        });

        // Enable parent and all child group checkboxes if the row is double clicked
        $("." + CLASSES.PARENT_GROUP, this.$element).dblclick(function() {
            let parentCheckbox = $(this).find(".boolean");
            parentCheckbox.prop("checked", !parentCheckbox.prop("checked"));

            let children = self.getGroupChildren(this);
            $.each(children, function(index, child) {
              let element = self.getElementFromGroupId(child.id);
              element.prop("checked", !element.prop("checked"));
            });

            let expandButton = $(this).find("." + CLASSES.EXPAND_BUTTON);
            if (expandButton.val() === "+" && parentCheckbox.prop("checked"))
              expandButton.click();
        });

        $("." + CLASSES.PARENT_GROUP + " .boolean, ." + CLASSES.CHILD_GROUP + " .boolean", this.$element).change(function () {
            if ($(this).prop("checked"))
                self.selectedGroupIds.push($(this).closest("." + CLASSES.PARENT_GROUP + ", ." + CLASSES.CHILD_GROUP).data("group-id"));
            else
                self.selectedGroupIds.filter(id => id !== $(this).closest("." + CLASSES.PARENT_GROUP + ", ." + CLASSES.CHILD_GROUP).data("group-id"));
            console.log(self.selectedGroupIds);
        });
    }

    // ************* Handlers *************

    expandGroupHandler(e) {
        let self = e.data.self;
        let button = e.data.button;
        $(button).attr("disabled", true); // Disable the button (until transition is complete)

        // Get the children of the parent group that was expanded/collapsed
        let children = self.getGroupChildren(button);

        // Toggle the collapse for each child of the parent group
        $.each(children, function(index, child) {
            self.toggleCollapse($("." + CLASSES.GROUP_CONTAINER_PREFIX + child.id, self.groupsElement).closest("." + CLASSES.COLLAPSE_CONTAINER));
        });
        
        if ($(button).val() == "+")
            $(button).val("-");
        else
            $(button).val("+");
    }

    selectAllHandler(e) {
        let self = e.data.self;
        let button = e.data.button;
    }

    clearAllHandler(e) {
        let self = e.data.self;
        let button = e.data.button;
    }

    saveHandler(e) {
        let self = e.data.self;
        let button = e.data.button;

        self.$element.modal('hide');
        self.$element.trigger("saveGroups");
    }

    // ************* Helpers *************

    // element is an element that contains a data field 'group-id'
    // adds an element to the selected groups array
    addSelectedGroup(element) {

    }

    // element is an element that contains a data field 'group-id'
    // removes an element from the selected groups array
    removeSelectedGroup(element) {

    }

    // jqObject is a jQuery object
    // toggles the collapse of the object
    toggleCollapse(jqObject) {
        jqObject.collapse('toggle');
    }

    // group_id is the ID of a group
    // returns the element relating to the group ID
    getElementFromGroupId(group_id) {
      return $("." + CLASSES.GROUP_PREFIX + group_id, this.$element);
    }

    // element is a DOM element that has 'group-id'
    // returns an array of child elements
    getGroupChildren(element) {
      let self = this;

      let parentId = parseInt($(element).data("group-id"));
      if (isNaN(parentId))
        return;

      return self.data.find(g => g.id === parentId).children;
    }
}
