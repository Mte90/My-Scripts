<?php
/**
 * WordPress Coding Standard.
 *
 * @package WPCS\WordPressCodingStandards
 * @link    https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards
 * @license https://opensource.org/licenses/MIT MIT
 */

/**
 * Check for proper spacing in array key references.
 *
 * @link    http://make.wordpress.org/core/handbook/coding-standards/php/#space-usage
 *
 * @package WPCS\WordPressCodingStandards
 *
 * @since   0.3.0
 * @since   0.7.0 This sniff now has the ability to fix a number of the issues it flags.
 */
class WordPress_Sniffs_Arrays_ArrayKeySpacingRestrictionsSniff implements PHP_CodeSniffer_Sniff {

	/**
	 * Returns an array of tokens this test wants to listen for.
	 *
	 * @return array
	 */
	public function register() {
		return array(
			T_OPEN_SQUARE_BRACKET,
		);

	}

	/**
	 * Processes this test, when one of its tokens is encountered.
	 *
	 * @param PHP_CodeSniffer_File $phpcsFile The file being scanned.
	 * @param int                  $stackPtr  The position of the current token
	 *                                        in the stack passed in $tokens.
	 *
	 * @return void
	 */
	public function process( PHP_CodeSniffer_File $phpcsFile, $stackPtr ) {
		$tokens = $phpcsFile->getTokens();

		$token = $tokens[ $stackPtr ];
		if ( ! isset( $token['bracket_closer'] ) ) {
			$phpcsFile->addWarning( 'Missing bracket closer.', $stackPtr, 'MissingBracketCloser' );
			return;
		}

		$need_spaces = $phpcsFile->findNext(
			array( T_CONSTANT_ENCAPSED_STRING, T_LNUMBER, T_WHITESPACE, T_MINUS ),
			( $stackPtr + 1 ),
			$token['bracket_closer'],
			true
		);

		$spaced1 = ( T_WHITESPACE === $tokens[ ( $stackPtr + 1 ) ]['code'] );
		$spaced2 = ( T_WHITESPACE === $tokens[ ( $token['bracket_closer'] - 1 ) ]['code'] );

	} // end process()

} // End class.
