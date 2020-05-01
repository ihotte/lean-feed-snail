/*!
 * OpenWrt Snail Theme v1.0.0
 *
 * Copyright 2016-2020 openwrt.org
 * Licensed under the Apache License v2.0
 * http://www.apache.org/licenses/LICENSE-2.0
 */

function openWebUI(path, port, host, protocol) {
	var defaulthost = (protocol ? protocol : location.protocol) + '//' + window.location.hostname + (port ? ':' + port : '');
	window.open((host ? host : defaulthost) + (path ? path : "/"));
};

$(function () {
	$('html,body').scrollTop(0);
	setTimeout(function () {
		$('html,body').scrollTop(0);
	}, 100);

	$('.cbi-input-password').on('focus', function (event) {
		var $this = $(this);
		$this.attr('type', 'text');
		$this.on('blur', function (event) {
			$this.attr('type', 'password');
		});
	});

	$('div[data-dynlist][data-password]').on('focus', '.cbi-input-text', function (event) {
		var $this = $(this);
		$this.attr('type', 'text');
		$this.on('blur', function (event) {
			$this.attr('type', 'password');
		});
	})
		.closest('.cbi-value').find('.cbi-value-title').on('click', function (event) {
			var $inputs = $(this).next('.cbi-value-field').find('.cbi-input-text');
			var type = $inputs.first().attr('type') == 'password' ? 'text' : 'password';
			$inputs.attr('type', type);
			setTimeout(function () {
				$inputs.attr('type', 'password');
			}, 5000);
		});
});

$(function () {
	$('.cbi-input-text').on('focus', function (event) {
		var $el = $(this)
		if (this.clientWidth < this.scrollWidth) {
			$el.data('origWidth', $el.width());
			$el.width(this.scrollWidth + 10);
			$el.css('transition-duration', '.2s');
			$el.css('max-width', '80%');

			$el.one('blur', function (event) {
				var width = $el.data('origWidth');
				if (width) {
					$el.width(width);
					$el.removeData('origWidth');
					$el.attr('style', function (i, style) {
						return style && style.replace(/width: [\d]+px;?/g, '');
					});
				}
			});
		}
	});
});


/**
 * 主题切换 && 壁纸切换
 */
$(function () {
	var style = $('.luci-admin-system.page-system div[id$="_style"]')
	var bgbox = $('.luci-admin-system.page-system div[id$="_bgbox"]')

	if (style.length || bgbox.style) {
		style.find('.cbi-input-radio').change(function () {
			$('#sctl').attr('href', $('#sctl').attr('href').replace(/\w+\.css.*/, $(this).val() + '.css?t=' + (new Date().getTime())))
		})

		bgbox.find('.cbi-input-radio').change(function () {
			$('#bgbox').removeAttr('class').addClass($(this).val())
		})
	}
});
