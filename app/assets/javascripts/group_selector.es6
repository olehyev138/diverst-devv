const STARTING_PAGE = 1;
const LIMIT = 10;
const MULTISELECT_DEFAULT = false;

const CLASSES = {
    CONTENT: 'groups-content',
    HEADER: 'modal-header',
    FOOTER: 'modal-footer',
    PARENT_GROUP: 'parent',
    CHILD_GROUP: 'child',
    COLLAPSE_CONTAINER: 'collapse-container',
    GROUP_CONTAINER_PREFIX: 'group_container_',
    GROUP_PREFIX: 'group_',
    EXPAND_BUTTON: 'expand-group-btn',
    SELECT_ALL_BUTTON: 'select-all-btn',
    CLEAR_BUTTON: 'clear-btn',
    SAVE_BUTTON: 'save-groups-btn',
    PAGINATION_ROW: 'pagination-row',
    HELPER_ROW: 'helper-row',
    TOTAL_PAGES_TEXT: 'total-pages-text',
    CURRENT_PAGE_TEXT: 'current-page-text',
    PAGINATION_TEXT: 'pagination-text',
    PAGINATION_BUTTON: 'pagination-button',
    NEXT_PAGE_BUTTON: 'next-page-btn',
    PREVIOUS_PAGE_BUTTON: 'previous-page-btn',
    FIRST_PAGE_BUTTON: 'first-page-btn',
    LAST_PAGE_BUTTON: 'last-page-btn',
    TITLE_CONTAINER: 'title-container',
    SEARCH_CONTAINER: 'search-container',
    SEARCH_INPUT: 'search-input',
    SEARCH_BUTTON: 'search-btn',
    CLEAR_SEARCH_BUTTON: 'clear-search-btn'
}

const EXPAND_BUTTON_TEXT = {
    EXPAND: "+",
    COLLAPSE: "&ndash;"
}

const PAGINATION_TEXT = {
    PREVIOUS: "&lsaquo;",
    NEXT: "&rsaquo;",
    FIRST: "&laquo;",
    LAST: "&raquo;"
}

const DEFAULT_GROUP_TEXT = {
    SINGULAR: "group",
    PLURALIZED: "groups"
}

// Reads from 2..3 data attributes on the group selector element itself
// 'data-multiselect' is a REQUIRED boolean value that switches the group selector between multi select or single select
// 'data-url' is a REQUIRED string that represents the URL to pull group data from
// 'data-all-url' is an OPTIONAL string that represents the URL to pull
class GroupSelector {
    constructor($element) {
        // $element is the actual jQuery object representing this instance of a group selector
        this.$element = $element;
        // multiselect is a boolean that defines whether multiple groups can be selected
        this.multiselect = this.$element.data('multiselect');
        // dataUrl is the URL that the group selector fetches from
        this.dataUrl = this.$element.data('url');
        // allDataUrl is the URL that the group selector 'Select All' fetches from
        this.allDataUrl = this.$element.data('all-url');
        // groupsElement is the jQuery object where group data will be inserted
        this.groupsElement = $("." + CLASSES.CONTENT, this.$element);


        // Store the data on the object so we can use it when expanding, etc.
        this.data = {};
        // Stores the currently selected groups
        this.selectedGroups = [];


        // Pagination & search variables
        this.currentPage = STARTING_PAGE;
        this.totalPages = this.currentPage;
        this.searchTerm = "";

        // Store instance in self, so that we can use access instance inside closures and event handlers
        let self = this;

        // Add title html
        $("." + CLASSES.TITLE_CONTAINER, this.$element).html(this.buildTitleHtml());

        // Add pagination html
        $("." + CLASSES.FOOTER + " > .row." + CLASSES.PAGINATION_ROW, this.$element).html(this.buildPaginationHtml());

        // Add selector helper html
        $("." + CLASSES.FOOTER + " > .row." + CLASSES.HELPER_ROW, this.$element).append(this.buildHelperHtml());

        // Add initial event listeners
        $("." + CLASSES.SAVE_BUTTON, this.$element).click({ self: self }, self.saveHandler);
        $("." + CLASSES.SELECT_ALL_BUTTON, this.$element).click({ self: self }, self.selectAllHandler);
        $("." + CLASSES.CLEAR_BUTTON, this.$element).click({ self: self }, self.clearHandler);
        $("." + CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).click({ self: self }, self.previousPageHandler);
        $("." + CLASSES.NEXT_PAGE_BUTTON, this.$element).click({ self: self }, self.nextPageHandler);
        $("." + CLASSES.FIRST_PAGE_BUTTON, this.$element).click({ self: self }, self.firstPageHandler);
        $("." + CLASSES.LAST_PAGE_BUTTON, this.$element).click({ self: self }, self.lastPageHandler);
        $("." + CLASSES.SEARCH_BUTTON, this.$element).click({ self: self }, self.searchHandler);
        $("." + CLASSES.CLEAR_SEARCH_BUTTON, this.$element).click({ self: self }, self.clearSearchHandler);

        $("." + CLASSES.SEARCH_INPUT, this.$element).keypress({ self: self }, function(e) {
            if (e.keyCode === 10 || e.keyCode === 13) {
              e.preventDefault();
              self.searchHandler(e);
            }
        });

        this.updateData();
    }

    updateData() {
        let self = this;

        $.get(this.dataUrl, { page: this.currentPage, limit: LIMIT, term: this.searchTerm }, (data) => {
            console.log(data);

            // Get the custom group text
            self.groupText = data.group_text;
            self.groupTextPluralized = data.group_text_pluralized;

            self.totalPages = data.total_pages; // Get the total page count

            // Update the group data
            self.data = data.groups;
            self.onDataUpdate();
        });
    }

    onDataUpdate() {
        let self = this;
        let data = this.data;

        this.groupsElement.html(''); // Clear the list of groups

        // The groups list is not defined or empty
        if (data == undefined || data.length == 0) {
            self.groupsElement.append('<div class="card__section"><h4>No results.</h4></div>');
            return;
        }

        // For each group, add it and it's children to the HTML
        $.each(data, function(i, group) {
            var html = self.buildGroupHtml(group, i == data.length - 1);

            $.each(group.children, function (j, child) {
                html += self.buildGroupHtml(child);
            });

            self.groupsElement.append(html);
        });

        // Post data calls
        this.checkSelectedGroups();
        this.addPostDataEventListeners();
        this.updatePaginationButtons();

        // Set the total pages count
        $("." + CLASSES.TOTAL_PAGES_TEXT, this.$element).text(self.totalPages);
    }

    // ************* HTML Builders *************

    buildGroupHtml(group, lastParentGroup = false) {
        var containerClass = CLASSES.CHILD_GROUP;
        var childIndicatorHtml = "";
        var groupLogoHtml = "";
        var expandButtonHtml = "";
        var booleanHtml = "";

        // The group is a parent
        if (!$.isNumeric(group.parent_id)) {
            // Don't put a border on the last parent
            if (lastParentGroup)
                containerClass = CLASSES.PARENT_GROUP;
            else
                containerClass = CLASSES.PARENT_GROUP + " card__section--border";

            // The group is a parent with children
            if (group.children != undefined && group.children.length > 0) {
                // Add the expand/collapse button
                expandButtonHtml = `
                    <div class="col pull-right">
                        <button type="button" class="${CLASSES.EXPAND_BUTTON} btn btn--tertiary btn--small" data-group-id="${group.id}">${EXPAND_BUTTON_TEXT.EXPAND}</button>
                    </div>
                `;
            }
        }
        else {
            childIndicatorHtml = `
                <div class="col">
                    <hr class="child-indicator">
                </div>
            `;
        }

        // The group has a logo
        if (group.logo_expiring_thumb) {
            // Add the group logo
            groupLogoHtml = `
                <div class="col group-logo-container">
                    <img src="${group.logo_expiring_thumb}" alt="${group.name} Logo" width="48px" height="48px">
                </div>
            `;
        }
        else {
            groupLogoHtml = `
                <div class="col group-logo-container" style="width: 48px;"></div>
            `;
        }

        if (this.multiselect === true) {
            booleanHtml = `
                <input value="0" type="hidden" class="${CLASSES.GROUP_PREFIX}${group.id}" name="${CLASSES.GROUP_PREFIX}${group.id}">
                <input type="checkbox" class="control__input boolean optional ${CLASSES.GROUP_PREFIX}${group.id}" name="${CLASSES.GROUP_PREFIX}${group.id}" data-group-id="${group.id}" data-group-name="${group.name}">
                <span class="control__indicator control__indicator--checkbox"></span>
            `;
        }
        else {
            booleanHtml = `
                <input type="radio" class="control__input radio ${CLASSES.GROUP_PREFIX}${group.id}" name="groups" value="${group.id}" data-group-id="${group.id}" data-group-name="${group.name}">
                <span class="control__indicator control__indicator--radio"></span>
            `;
        }

        let groupHtml = `
            <div class="${containerClass} card__section ${CLASSES.GROUP_CONTAINER_PREFIX}${group.id}" data-group-id="${group.id}" data-group-name="${group.name}">
                <div class="row">
                    ${childIndicatorHtml}
                    ${groupLogoHtml}
                    <div class="col">
                        <label class="control">
                            ${booleanHtml}
                        </label>
                    </div>
                    <div class="col">
                        ${group.name}
                    </div>
                    ${expandButtonHtml}
                </div>
            </div>
        `;

        // The group is a parent
        if ($.isNumeric(group.parent_id)) {
            // Return collapsed HTML
            return `
                <div class="${CLASSES.COLLAPSE_CONTAINER} collapse card__section--border">
                    ${groupHtml}
                </div>
            `;
        }
        else
            return groupHtml; // Return normal HTML
    }

    buildTitleHtml() {
        var title = "";
        var subText = "";
        var closeButton = '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>';

        var groupText = this.groupText;
        var groupTextPluralized = this.groupTextPluralized;

        if (!groupText) {
            groupText = DEFAULT_GROUP_TEXT.SINGULAR;
            groupTextPluralized = DEFAULT_GROUP_TEXT.PLURALIZED;
        }

        if ((this.multiselect == null))
            this.multiselect = MULTISELECT_DEFAULT;

        if (this.multiselect == true) {
            title = groupTextPluralized;
            subText = "<small>Double click to select all sub-" + groupTextPluralized + "</small>";
        }
        else
            title = groupText;

        return closeButton + '<h4 class="modal-title">Choose ' + title + '</h4>' + subText;
    }

    buildPaginationHtml() {
        var html = `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${CLASSES.PAGINATION_BUTTON} ${CLASSES.FIRST_PAGE_BUTTON}">${PAGINATION_TEXT.FIRST}</button>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${CLASSES.PAGINATION_BUTTON} ${CLASSES.PREVIOUS_PAGE_BUTTON}">${PAGINATION_TEXT.PREVIOUS}</button>
            </div>
            <div class="col">
                <div class="${CLASSES.PAGINATION_TEXT}">
                    <span class="${CLASSES.CURRENT_PAGE_TEXT}">${STARTING_PAGE}</span>/<span class="${CLASSES.TOTAL_PAGES_TEXT}">${STARTING_PAGE}</span>
                </div>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${CLASSES.PAGINATION_BUTTON} ${CLASSES.NEXT_PAGE_BUTTON}">${PAGINATION_TEXT.NEXT}</button>
            </div>
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--extra--small ${CLASSES.PAGINATION_BUTTON} ${CLASSES.LAST_PAGE_BUTTON}">${PAGINATION_TEXT.LAST}</button>
            </div>
        `;

        return html;
    }

    buildHelperHtml() {
        var helperHtml = "";

        if (this.allDataUrl && this.multiselect) {
          helperHtml += `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--small ${CLASSES.SELECT_ALL_BUTTON}">Select All</button>
            </div>
          `;
        }

        helperHtml += `
            <div class="col">
                <button type="button" class="btn btn--tertiary btn--small ${CLASSES.CLEAR_BUTTON}">Clear</button>
            </div>
        `;

        return helperHtml;
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

        var lastParentElement = $("." + CLASSES.PARENT_GROUP + ":last-of-type", this.groupsElement);
        lastParentElement.hasClass("card__section--border") ? lastParentElement.removeClass("card__section--border") : lastParentElement.addClass("card__section--border");
        
        // Toggle the expand/collapse button text
        $(button).html() == EXPAND_BUTTON_TEXT.EXPAND ? $(button).html(EXPAND_BUTTON_TEXT.COLLAPSE) : $(button).html(EXPAND_BUTTON_TEXT.EXPAND);

        // Toggle the expand/collapse button classes
        $(button).hasClass("expanded") ? $(button).removeClass("expanded") : $(button).addClass("expanded");
    }

    selectAllHandler(e) {
        let self = e.data.self;

        if (!self.allDataUrl)
            return;

        self.selectedGroups = [];

        $.get(self.allDataUrl, { term: self.searchTerm }, (data) => {
            $.each(data, function(index, group) {
                self.addToSelectedGroups(group.id, group.text);
            });

            self.checkSelectedGroups();
        });

        console.log(self.selectedGroups);
    }

    clearHandler(e) {
        let self = e.data.self;

        self.selectedGroups = [];

        $(".boolean, .radio", self.groupsElement).each(function() {
            $(this).prop("checked", false);
        });

        console.log(self.selectedGroups);
    }

    saveHandler(e) {
        let self = e.data.self;

        self.$element.modal('hide');
        self.$element.trigger("saveGroups", [self.selectedGroups]);
    }

    previousPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage > STARTING_PAGE) {
            self.currentPage--;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    nextPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage < self.totalPages) {
            self.currentPage++;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    firstPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage != STARTING_PAGE) {
            self.currentPage = STARTING_PAGE;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }
    
    lastPageHandler(e) {
        let self = e.data.self;

        if (self.currentPage != self.totalPages) {
            self.currentPage = self.totalPages;
            self.updateCurrentPageText();
            self.updatePaginationButtons();
            self.updateData();
        }
    }

    searchHandler(e) {
      let self = e.data.self;

      self.searchTerm = $("." + CLASSES.SEARCH_INPUT, this.$element).val();
      self.updateData();
    }

    clearSearchHandler(e) {
      let self = e.data.self;

      self.searchTerm = "";
      $("." + CLASSES.SEARCH_INPUT).val("");
      self.updateData();
    }


    // ************* Helpers *************


    // Adds the event listeners for elements created on data pull
    addPostDataEventListeners() {
        let self = this;

        // Add event listener for the expand buttons
        $("." + CLASSES.EXPAND_BUTTON, this.groupsElement).each(function() {
            $(this).on('click', { self: self, button: this }, self.expandGroupHandler);

            // Enable expand/collapse button when expand/collapse is complete
            var button = this;
            $(button).closest("." + CLASSES.PARENT_GROUP).siblings("." + CLASSES.COLLAPSE_CONTAINER).on('shown.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });

            $(button).closest("." + CLASSES.PARENT_GROUP).siblings("." + CLASSES.COLLAPSE_CONTAINER).on('hidden.bs.collapse', function () {
                $(button).removeAttr("disabled");
            });
        });

        // *************** Single select Event Listeners ***************

        // Enable the group radio button if the row is clicked
        $("." + CLASSES.PARENT_GROUP + ", ." + CLASSES.CHILD_GROUP, this.groupsElement).click(function (e) {
          let radio = $(this).find(".radio");
          if (!radio.length || $(e.target).hasClass(CLASSES.EXPAND_BUTTON) || $(e.target).hasClass('radio') || $(e.target).hasClass('control__indicator--radio'))
            return;

          radio.prop("checked", true);
          self.setElementAsSelectedGroup(radio);
        });

        // Add or remove selected group if checkbox is checked
        $(".radio", this.groupsElement).click(function () {
          self.setElementAsSelectedGroup(this);
        });

        // *************** Multiselect Event Listeners ***************

        // Enable the group checkbox if the row is clicked
        $("." + CLASSES.PARENT_GROUP + ", ." + CLASSES.CHILD_GROUP, this.groupsElement).click(function (e) {
            let checkbox = $(this).find(".boolean");
            if (!checkbox.length ||  $(e.target).hasClass(CLASSES.EXPAND_BUTTON) || $(e.target).hasClass('boolean') || $(e.target).hasClass('control__indicator--checkbox'))
                return;

            checkbox.prop("checked", !checkbox.prop("checked"));

            if (checkbox.prop("checked"))
                self.addElementAsSelectedGroup(checkbox);
            else
                self.removeElementAsSelectedGroup(checkbox);
        });

        // Add or remove selected group if checkbox is checked
        $(".boolean", this.groupsElement).click(function () {
            if ($(this).prop("checked"))
                self.addElementAsSelectedGroup(this);
            else
                self.removeElementAsSelectedGroup(this);
        });

        // Enable parent and all child group checkboxes if the row is double clicked
        $("." + CLASSES.PARENT_GROUP, this.groupsElement).dblclick(function(e) {
            if ($(e.target).hasClass(CLASSES.EXPAND_BUTTON) || $(e.target).hasClass('boolean') || $(e.target).hasClass('control__indicator--checkbox'))
                return;

            let parentCheckbox = $(this).find(".boolean");

            if (!parentCheckbox.length)
              return;

            parentCheckbox.prop("checked", !parentCheckbox.prop("checked"));

            if (parentCheckbox.prop("checked"))
                self.addElementAsSelectedGroup(parentCheckbox);
            else
                self.removeElementAsSelectedGroup(parentCheckbox);

            let children = self.getGroupChildren(this);
            $.each(children, function(index, child) {
                let childCheckbox = self.getElementFromGroupId(child.id);
                childCheckbox.prop("checked", parentCheckbox.prop("checked"));

                if (childCheckbox.prop("checked"))
                    self.addElementAsSelectedGroup(childCheckbox);
                else
                    self.removeElementAsSelectedGroup(childCheckbox);
            });

            let expandButton = $(this).find("." + CLASSES.EXPAND_BUTTON);
            if (expandButton.html() === EXPAND_BUTTON_TEXT.EXPAND && parentCheckbox.prop("checked"))
                expandButton.click();
        });
    }

    // Checks all boxes who's group is in the selected groups array
    checkSelectedGroups() {
        let self = this;

        $(".boolean, .radio", this.groupsElement).each(function() {
            if (self.selectedGroups.some(group => group.id === $(this).data("group-id"))) {
                $(this).prop("checked", true);
            }
        });
    }

    // Updates the "current page" text
    updateCurrentPageText() {
        let self = this;
    
        $("." + CLASSES.CURRENT_PAGE_TEXT).text(self.currentPage);
    }

    updatePaginationButtons() {
        if (this.currentPage <= STARTING_PAGE) {
            $("." + CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).attr("disabled", true);
            $("." + CLASSES.FIRST_PAGE_BUTTON, this.$element).attr("disabled", true);
        }
        else {
            $("." + CLASSES.PREVIOUS_PAGE_BUTTON, this.$element).attr("disabled", false);
            $("." + CLASSES.FIRST_PAGE_BUTTON, this.$element).attr("disabled", false);
        }

        if (this.currentPage >= this.totalPages) {
            $("." + CLASSES.NEXT_PAGE_BUTTON, this.$element).attr("disabled", true);
            $("." + CLASSES.LAST_PAGE_BUTTON, this.$element).attr("disabled", true);
        }
        else {
            $("." + CLASSES.NEXT_PAGE_BUTTON, this.$element).attr("disabled", false);
            $("." + CLASSES.LAST_PAGE_BUTTON, this.$element).attr("disabled", false);
        }
    }

    // element is an element that contains a data field 'group-id'
    // Gets the group ID from the HTML element and sets it as the only selected group
    setElementAsSelectedGroup(element) {
      this.selectedGroups = [];
      this.addElementAsSelectedGroup(element);
    }

    // element is an element that contains a data field 'group-id'
    // Gets the group ID from the HTML element and adds it to the selected groups array
    addElementAsSelectedGroup(element) {
        this.addToSelectedGroups($(element).data("group-id"), $(element).data("group-name"));
    }

    // element is an element that contains a data field 'group-id'
    // Gets the group ID from the HTML element and removes it from the selected groups array
    removeElementAsSelectedGroup(element) {
        this.removeFromSelectedGroups($(element).data("group-id"));
    }

    // groupId is the ID of the group to add
    // Adds a group ID to the array of selected group IDs
    addToSelectedGroups(groupId, groupName) {
        if (!$.isNumeric(groupId))
            return;

        this.selectedGroups.push({ id: groupId, text: groupName });
        console.log(this.selectedGroups);
    }

    // groupId is the ID of the group to remove
    // Removes a group ID from the array of selected group IDs
    removeFromSelectedGroups(groupId) {
        var idx = this.selectedGroups.findIndex(group => group.id === groupId)
        if (idx == -1)
            return;

        this.selectedGroups.splice(idx, 1);
        console.log(this.selectedGroups);
    }

    // jqObject is a jQuery object
    // Toggles the collapse of the object
    toggleCollapse(jqObject) {
        jqObject.collapse('toggle');
    }

    // group_id is the ID of a group
    // Returns the element relating to the group ID
    getElementFromGroupId(group_id) {
      return $(".boolean." + CLASSES.GROUP_PREFIX + group_id, this.groupsElement);
    }

    // element is a DOM element that has 'group-id'
    // Returns an array of child elements
    getGroupChildren(element) {
      let self = this;

      let parentId = parseInt($(element).data("group-id"));
      if (isNaN(parentId))
        return;

      return self.data.find(g => g.id === parentId).children;
    }
}
