/*
Author : Ellorex,
Year: 2020
*/
//var select = new CustomSelect('.select', { 'filter_placeholder': 'Pick a country', 'filter_threshold': 1 });


function CustomSelect(target, settings) {
    var that = this;
    that.target = null;
    that.select = null;
    that.display = null;
    that.list = null;
    that.ul = null;
    that.options = [];
    that.isLarge = false;
    that.value = null;
    that.selected = null;
    that.settings = null;
    that.highlighted = null;
    that.nomatch = null;


    that.init = function () {
        switch (typeof target) {
            case 'object':
                that.target = target;
                break;
            case 'string':
                that.target = document.querySelector(target);
                break;
        }
        that.settings = that.getSettings(settings);
        that.buildSelect();
        document.addEventListener('click', that.clickOutside.bind(this));
    }

    that.buildSelect = function () {
        // adding wrapper
        //var iSelect = document.querySelectorAll('.cselect-wrapper') || [];
        //if (iSelect != null) {
        //    iSelect[0].remove();
        //}        

        that.select = document.createElement('div');
        that.select.classList.add('cselect-wrapper');
        that.select.setAttribute('tabindex', that.target.tabIndex);
        that.select.addEventListener('keydown', that.keyboardNav.bind(this))

        // adding span that displays the value when the dropdown is closed
        that.display = document.createElement('span');
        that.display.classList.add('value');
        that.select.appendChild(that.display);

        // adding list wrapper
        that.list = document.createElement('div');
        that.list.classList.add('list');
        that.list.setAttribute('tabindex', '-1');
        that.select.appendChild(that.list);

        // adding input filter and its wrapper
        var wrapper = document.createElement('div');
        wrapper.classList.add('filter');
        that.filter = document.createElement('input');
        that.filter.type = 'text';
        that.filter.setAttribute('placeholder', 'Seleccione');
        wrapper.appendChild(that.filter);
        that.list.appendChild(wrapper);
        that.filter.addEventListener('input', that.filterOptions.bind(that));

        // adding list
        ul = document.createElement('ul');
        options = that.target.querySelectorAll('option');

        for (var i = 0; i < options.length; i++) {
            var li = document.createElement('li');
            li.setAttribute('data-value', options[i].value);
            li.innerHTML = options[i].innerHTML;
            li.addEventListener('click', that.clickOnOption.bind(this));
            li.addEventListener('mouseover', that.hoverOption.bind(this));
            li.addEventListener('mouseout', that.clearHover.bind(this));

            ul.appendChild(li);
            that.options.push(li);
        }

        that.list.appendChild(ul);

        // message if no result
        that.nomatch = document.createElement('div');
        that.nomatch.classList.add('no-match');
        that.list.appendChild(that.nomatch);

        // span html content
        if (that.options.length) {
            that.value = that.options[that.target.selectedIndex].getAttribute('data-value');
            that.selected = that.options[that.target.selectedIndex];
            that.display.innerHTML = that.selected.innerHTML;
        }
        that.display.addEventListener('click', function (e) {
            that.showOptions();
        })

        // replacing native select by our custom select
        that.target.parentNode.replaceChild(that.select, that.target);
        that.target.classList.add('invisible-cselect');
        that.select.appendChild(that.target);

    } //end buildselect

    that.getSettings = function (settings) {
        var defaults = {
            filtered: 'auto',
            filter_threshold: 1,
            filter_placeholder: 'Search'
        };

        for (var p in settings) {
            defaults[p] = settings[p];
        }

        return defaults;
    };


    that.filterOptions = function () {
        // filter function 

        // handling accents and hyphens
        handleAccents = function (input) {
            var r = input.toLowerCase();
            char_arr = { 'a': '[àáâãäå]', 'ae': 'æ', 'c': 'ç', 'e': '[èéêë]', 'i': '[ìíîï]', 'n': 'ñ', 'o': '[òóôõö]', 'oe': 'œ', 'u': '[ùúûűü]', 'y': '[ýÿ]', '-': ' ' };
            for (i in char_arr) { r = r.replace(new RegExp(char_arr[i], 'g'), i); }
            return r;
        };

        that.options.filter(function (li) {

            if ((handleAccents(li.innerHTML).indexOf(handleAccents(that.filter.value))) == -1) {
                li.style.display = 'none';
                if (li.classList.contains('highlighted')) {
                    li.classList.remove('highlighted');
                }
            } else {
                li.style.display = 'block';
            }
        });

        // message if no result
        if (that.filter.value) {
            let results = that.options.filter((item) => item.style.display !== "none");
            if (results.length === 0) {
                that.nomatch.innerHTML = "No resultados para -" + that.filter.value + "-";
                that.nomatch.style.display = "block";
            } else {
                that.nomatch.style.display = "none";
                that.nomatch.innerHTML = " ";
            }
        }
    }

    that.clearFilter = function () {
        that.filter.value = "";
        for (var i = 0; i < that.options.length; i++) {
            that.options[i].style.display = 'block';
        }
    }

    that.toggleOptions = function () {
        // opening and closing list 
        if (that.select.classList.contains('open')) {
            that.hideOptions();
        } else {
            that.showOptions();
        }
    }

    that.showOptions = function () {
        // opening list
        that.select.setAttribute('aria-expanded', true);
        that.select.classList.add('open');
        that.filter.focus();
        that.options[0].parentNode.scrollTop = that.options[0].offsetTop - that.options[0].parentNode.offsetTop;
    }

    that.hideOptions = function () {
        // closing list 
        that.select.classList.remove('open');
        that.select.setAttribute('aria-expanded', false);
        that.select.focus();
        for (var i = 0; i < that.options.length; i++) {
            if (that.options[i].classList.contains('hovered')) {
                that.options[i].classList.remove('hovered');
            }
            if (that.options[i].classList.contains('highlighted')) {
                that.options[i].classList.remove('highlighted');
            }
        }
        that.clearFilter();
    }

    that.hoverOption = function (e) {
        e.target.classList.add('hovered');
    }

    that.clearHover = function (e) {
        e.target.classList.remove('hovered');
    }

    that.clickOnOption = function (e) {
        that.display.innerHTML = e.target.innerHTML;
        that.target.value = e.target.getAttribute('data-value');
        that.value = that.target.value;
        that.selected = e.target;

        that.hideOptions();
        that.clearFilter();

        var evnt = document.createEvent("Event");
        evnt.initEvent("change", false, true);
        this.target.dispatchEvent(evnt);
    }

    that.clickOutside = function (e) {
        // closing list when clicking anywhere else on the page
        if (that.select.classList.contains('open')) {
            if (!that.select.contains(e.target)) {
                that.hideOptions();
            }
        }
    }

    that.keyboardNav = function (e) {
        var keycode = (e.keyCode ? e.keyCode : e.which);
        switch (keycode) {
            case 40: // down
                this.navigateOptions('down');
                break;
            case 38: // up
                this.navigateOptions('up')
                break;
            case 13: // enter - opens list if closed or selects a highlighted option
                e.preventDefault();
                if (!that.select.classList.contains('open')) {
                    that.showOptions();
                } else if (that.list.querySelector('li.highlighted')) {
                    that.list.querySelector('li.highlighted').click();
                }
                break;
            case 32: // space 
                if (!that.select.classList.contains('open')) {
                    e.preventDefault;
                    that.showOptions();
                }
                break;
            case 27: // esc
                that.hideOptions();
                break;
            default:
                break;
        }
    }
    this.navigateOptions = function (dir) {
        let siblings = that.options.filter((item) => item.style.display !== "none");
        //navigating only through visible options
        if (that.list.querySelectorAll('li.highlighted').length > 0) {
            // if an option is already highlighted, moving selection according to the arrow direction
            // also moving scroll so that the option is visible

            for (var i = 0; i < siblings.length; i++) {
                if (siblings[i].classList.contains('highlighted') && (siblings[i].style.display !== "none")) {

                    if (dir === "down" && i !== (siblings.length - 1)) {
                        siblings[i].classList.remove('highlighted');
                        siblings[i + 1].classList.add('highlighted');
                        siblings[i + 1].parentNode.scrollTop = siblings[i + 1].offsetTop - siblings[i + 1].parentNode.offsetTop;
                    } else if (dir === "up" && i !== 0) {
                        siblings[i].classList.remove('highlighted');
                        siblings[i - 1].classList.add('highlighted');
                        siblings[i - 1].parentNode.scrollTop = siblings[i - 1].offsetTop - siblings[i - 1].parentNode.offsetTop;
                    }
                    break;
                }
            }
        } else {
            // if no option is highlighted, selecting the first visible option
            // if list is closed, opening it
            siblings[0].classList.add('highlighted');
            if (!that.select.classList.contains('open')) {
                that.showOptions();
            }
        }
    }
    that.init();
}