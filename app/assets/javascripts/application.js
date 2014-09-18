// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function () {
	var selected_player = false;
	var mode_select_url = 'http://10.0.0.119:6300/screens/update_mode';
	var champ_select_url = 'http://10.0.0.119:6300/screens/update';

	var player_list = $('.player');
	player_list.on('click', function (e) {
		e.preventDefault();

		var $this = $(this);
		if ($this.hasClass('active')) {
			selected_player = false;
			player_list.removeClass('active');
		} else {
			player_list.removeClass('active');
			$this.addClass('active');
			selected_player = $.trim($this.text()).toLowerCase().replace('player ', '');
		}
	});

	var champ_elements = $('li', '#champion-grid-content');

	// This is where we do stuff when someone clicks on a character
	champ_elements.on('click', function () {
		if (!selected_player) {
			alert('You must select a player first!');
			return false;
		}

		// Get the character name and strip out the characters we don't want
		var name = $.trim($(this).text()).replace(/[\W ]/g, '');
		if (name) {
			if (name != 'Blank-') {
				name += '_0.jpg';
			}

			// TODO Delete this alert() once you're done testing, otherwise nothing will happen until you click ok on the popup
			//alert('You clicked on ' + name );

			// Do an AJAX call to the ruby app
			$.ajax({
				url: champ_select_url,
				type: 'POST',
				data: {'filename': name, 'player': selected_player, authenticity_token: AUTH_TOKEN}
			}).done(function (result) {
				// All done :)
				selected_player = false;
				player_list.removeClass('active');
				champion_search.val('').trigger('keyup');
			}).fail(function (result) {
				// We probably care if it failed
				console.log(result);
				alert('Something went all wrong :(')
			});
		}
	});

	// Bind the 'blank all' button
	$('.blank-all').on('click', function(e) {
		e.preventDefault();
		if (!confirm('Are you sure you want to reset *ALL* players to "blank"?')) {
			return false;
		}

		// Do an AJAX call to the ruby app for each player
		for (var i = 1; i <= 10; i++) {
			$.ajax({
				url: champ_select_url,
				type: 'POST',
				data: {'filename': 'Blank', 'player': i}
			}).done(function (result) {
				// All done :)
				selected_player = false;
				player_list.removeClass('active');
				champion_search.val('').trigger('keyup');
			}).fail(function (result) {
				// We probably care if it failed
				console.log(result);
				alert('Something went all wrong :(')
			});
		}
	});

	// Bind to the mode select buttons
	$('.mode-select').on('click', function(e) {
		e.preventDefault();

		var mode = $.trim($(this).text()).toLowerCase();
		$.ajax({
			url: mode_select_url,
			type: 'POST',
			data: {'mode': mode}
		}).done(function (result) {
			// All done :)
		}).fail(function (result) {
			// We probably care if it failed
			console.log(result);
			alert('Something went all wrong :(')
		});
	});

	// Character filter "magic" with global binding
	var trigger_alerts = true;
	var champion_search = $('#champion-search');
	$(document).on('keyup', function (e) {
		if (e.which == 27) {
			// "esc" key pressed, clear the search and player selection
			champion_search.val('').trigger('keyup').focus();
			selected_player = false;
			player_list.removeClass('active');
			trigger_alerts = true;
			return false;
		}
		if ($.inArray(e.which, numeric_char_codes) >= 0) {
			// We've type a number, treat it as selecting a Player 1-10 (0 = 10)
			// actual_key here is to deal with numpad numbers giving the wrong character codes
			var actual_key = (e.which >= 96) ? e.which - 48 : e.which;
			champion_search.val(champion_search.val().substr(0, champion_search.val().length - 1));
			$('#player-' + String.fromCharCode(actual_key)).trigger('click');
			trigger_alerts = true;
			return false;
		}
		// If we haven't been typing into the search field, update the search field and give it focus
		if (e.target != champion_search[0]) {
			champion_search.val(champion_search.val() + String.fromCharCode(e.which).toLowerCase()).focus();
		}

		// This is where we actually filter the list and show/hide them appropriately
		var val = champion_search.val().toLowerCase().replace(/[\W ]/g, '');
		var available_champs = champ_elements.children('div').removeClass('active');
		if (!val) {
			champ_elements.show();
		} else {
			champ_elements.each(function () {
				var $this = $(this);
				var id = $this.attr('id');
				// Toggle the visibility based on whether the text entered is contained in the name
				$this.toggle(id.toLowerCase().replace('champion-grid-', '').indexOf(val) >= 0)
			});
			available_champs = available_champs.filter(':visible');
			if (available_champs.length == 1) {
				available_champs.addClass('active');
				// If there's only 1 champion left and we pressed "enter" and we haven't already shown a potential alert, trigger a click
				if (e.which == 13 && trigger_alerts) {
					available_champs.closest('li').trigger('click');
				}
			}
		}
		// This prevent alerts showing up when we press enter to close an alert
		trigger_alerts = (e.which != 13);
	});

	/** numeric_char_codes contains the charCodes of numbers that we want to bind as player selection hotkeys */
	var numeric_char_codes = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105];


});
