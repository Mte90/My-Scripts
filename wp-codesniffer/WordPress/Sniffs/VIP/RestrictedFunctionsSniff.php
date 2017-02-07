<?php
/**
 * WordPress Coding Standard.
 *
 * @package WPCS\WordPressCodingStandards
 * @link    https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards
 * @license https://opensource.org/licenses/MIT MIT
 */

/**
 * Restricts usage of some functions in VIP context.
 *
 * @package WPCS\WordPressCodingStandards
 *
 * @since   0.3.0
 * @since   0.10.0 The checks for `extract()` and the POSIX functions have been replaced by
 *                 the stand-alone sniffs WordPress_Sniffs_Functions_DontExtractSniff and
 *                 WordPress_Sniffs_PHP_POSIXFunctionsSniff respectively.
 */
class WordPress_Sniffs_VIP_RestrictedFunctionsSniff extends WordPress_AbstractFunctionRestrictionsSniff {

	/**
	 * Groups of functions to restrict.
	 *
	 * Example: groups => array(
	 * 	'lambda' => array(
	 * 		'type'      => 'error' | 'warning',
	 * 		'message'   => 'Use anonymous functions instead please!',
	 * 		'functions' => array( 'eval', 'create_function' ),
	 * 	)
	 * )
	 *
	 * @return array
	 */
	public function getGroups() {
		return array(
			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#switch_to_blog
			'switch_to_blog' => array(
				'type'      => 'error',
				'message'   => '%s is not something you should ever need to do in a VIP theme context. Instead use an API (XML-RPC, REST) to interact with other sites if needed.',
				'functions' => array( 'switch_to_blog' ),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#eval-and-create_function
			'create_function' => array(
				'type'      => 'warning',
				'message'   => '%s is discouraged, please use Anonymous functions instead.',
				'functions' => array(
					'create_function',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#eval-and-create_function
			'eval' => array(
				'type'      => 'error',
				'message'   => '%s is prohibited, please use Anonymous functions instead.',
				'functions' => array(
					'eval',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#custom-roles
			'custom_role' => array(
				'type'      => 'error',
				'message'   => 'Use wpcom_vip_add_role() instead of add_role()',
				'functions' => array(
					'add_role',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#caching-constraints
			'cookies' => array(
				'type'      => 'warning',
				'message'   => 'Due to using Batcache, server side based client related logic will not work, use JS instead.',
				'functions' => array(
					'setcookie',
				),
			),

			// @todo Introduce a sniff specific to get_posts() that checks for suppress_filters=>false being supplied.
			'get_posts' => array(
				'type'      => 'warning',
				'message'   => '%s is discouraged in favor of creating a new WP_Query() so that Advanced Post Cache will cache the query, unless you explicitly supply suppress_filters => false.',
				'functions' => array(
					'get_posts',
					'wp_get_recent_posts',
					'get_children',
				),
			),

			'wp_get_post_terms' => array(
				'type'      => 'error',
				'message'   => '%s is highly discouraged due to not being cached; please use get_the_terms() along with wp_list_pluck() to extract the IDs.',
				'functions' => array(
					'wp_get_post_terms',
					'wp_get_post_categories',
					'wp_get_post_tags',
					'wp_get_object_terms',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#use-wp_parse_url-instead-of-parse_url
			'parse_url' => array(
				'type'      => 'warning',
				'message'   => '%s is discouraged due to a lack for backwards-compatibility in PHP versions; please use wp_parse_url() instead.',
				'functions' => array(
					'parse_url',
				),
			),

			'get_intermediate_image_sizes' => array(
				'type'      => 'error',
				'message'   => 'Intermediate images do not exist on the VIP platform, and thus get_intermediate_image_sizes() returns an empty array() on the platform. This behavior is intentional to prevent WordPress from generating multiple thumbnails when images are uploaded.',
				'functions' => array(
					'get_intermediate_image_sizes',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#commented-out-code-debug-code-or-output
			'error_log' => array(
				'type'      => 'error',
				'message'   => '%s Debug code is not allowed on VIP Production',
				'functions' => array(
					'error_log',
					'var_dump',
					'print_r',
					'trigger_error',
					'set_error_handler',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#use-wp_safe_redirect-instead-of-wp_redirect
			'wp_redirect' => array(
				'type'     => 'warning',
				'message'   => '%s Using wp_safe_redirect(), along with the allowed_redirect_hosts filter, can help avoid any chances of malicious redirects within code. It’s also important to remember to call exit() after a redirect so that no other unwanted code is executed.',
				'functions' => array(
					'wp_redirect',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#mobile-detection
			'wp_is_mobile' => array(
				'type'      => 'error',
				'message'   => '%s When targeting mobile visitors, jetpack_is_mobile() should be used instead of wp_is_mobile. It is more robust and works better with full page caching.',
				'functions' => array(
					'wp_is_mobile',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#encoding-values-used-when-creating-a-url-or-passed-to-add_query_arg
			'urlencode' => array(
				'type'      => 'warning',
				'message'   => '%s should only be used when dealing with legacy applications, rawurlencode() should now be used instead. See http://php.net/manual/en/function.rawurlencode.php and http://www.faqs.org/rfcs/rfc3986.html',
				'functions' => array(
					'urlencode',
				),
			),

			// @link https://vip.wordpress.com/documentation/vip/code-review-what-we-look-for/#settings-alteration
			'runtime_configuration' => array(
				'type'      => 'error',
				'message'   => '%s is prohibited, changing configuration at runtime is not allowed on VIP Production.',
				'functions' => array(
					'dl',
					'error_reporting',
					'ini_alter',
					'ini_restore',
					'ini_set',
					'magic_quotes_runtime',
					'set_magic_quotes_runtime',
					'apache_setenv',
					'putenv',
					'set_include_path',
					'restore_include_path',
				),
			),

			'prevent_path_disclosure' => array(
				'type'      => 'error',
				'message'   => '%s is prohibited as it can lead to full path disclosure.',
				'functions' => array(
					'error_reporting',
					'phpinfo',
				),
			),

		);
	} // end getGroups()

} // End class.
