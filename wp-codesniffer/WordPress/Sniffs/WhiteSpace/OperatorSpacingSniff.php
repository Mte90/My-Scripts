<?php
/**
 * WordPress Coding Standard.
 *
 * @package WPCS\WordPressCodingStandards
 * @link    https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards
 * @license https://opensource.org/licenses/MIT MIT
 */

/**
 * Verify operator spacing, based upon Squiz code.
 *
 * "Always put spaces after commas, and on both sides of logical, comparison, string and assignment operators."
 *
 * @link    https://make.wordpress.org/core/handbook/best-practices/coding-standards/php/#space-usage
 *
 * @package WPCS\WordPressCodingStandards
 *
 * @since   0.1.0
 * @since   0.3.0 This sniff now has the ability to fix the issues it flags.
 *
 * Last synced with base class December 2008 at commit f01746fd1c89e98174b16c76efd325825eb58bf1.
 * @link    https://github.com/squizlabs/PHP_CodeSniffer/blob/master/CodeSniffer/Standards/Squiz/Sniffs/WhiteSpace/OperatorSpacingSniff.php
 */
class WordPress_Sniffs_WhiteSpace_OperatorSpacingSniff implements PHP_CodeSniffer_Sniff {

	/**
	 * A list of tokenizers this sniff supports.
	 *
	 * @var array
	 */
	public $supportedTokenizers = array(
		'PHP',
		'JS',
	);

	/**
	 * Returns an array of tokens this test wants to listen for.
	 *
	 * @return array
	 */
	public function register() {
		$comparison = PHP_CodeSniffer_Tokens::$comparisonTokens;
		$operators	= PHP_CodeSniffer_Tokens::$operators;
		$assignment = PHP_CodeSniffer_Tokens::$assignmentTokens;

		$tokens   = array_unique( array_merge( $comparison, $operators, $assignment ) );
		$tokens[] = T_BOOLEAN_NOT;

		return $tokens;

	}

	/**
	 * Processes this sniff, when one of its tokens is encountered.
	 *
	 * @param PHP_CodeSniffer_File $phpcsFile The current file being checked.
	 * @param int                  $stackPtr  The position of the current token in the
	 *                                        stack passed in $tokens.
	 *
	 * @return void
	 */
	public function process( PHP_CodeSniffer_File $phpcsFile, $stackPtr ) {
		$tokens = $phpcsFile->getTokens();

		if ( T_EQUAL === $tokens[ $stackPtr ]['code'] ) {
			// Skip for '=&' case.
			if ( isset( $tokens[ ( $stackPtr + 1 ) ] ) && T_BITWISE_AND === $tokens[ ( $stackPtr + 1 ) ]['code'] ) {
				return;
			}

			// Skip default values in function declarations.
			if ( isset( $tokens[ $stackPtr ]['nested_parenthesis'] ) ) {
				$bracket = end( $tokens[ $stackPtr ]['nested_parenthesis'] );
				if ( isset( $tokens[ $bracket ]['parenthesis_owner'] ) ) {
					$function = $tokens[ $bracket ]['parenthesis_owner'];
					if ( T_FUNCTION === $tokens[ $function ]['code'] ) {
						return;
					}
				}
			}
		}

		if ( T_BITWISE_AND === $tokens[ $stackPtr ]['code'] ) {
			/*
			// If it's not a reference, then we expect one space either side of the
			// bitwise operator.
			if ( false === $phpcsFile->isReference( $stackPtr ) ) {
				// @todo Implement or remove ?
			}
			*/
			return;

		} else {
			if ( T_MINUS === $tokens[ $stackPtr ]['code'] ) {
				// Check minus spacing, but make sure we aren't just assigning
				// a minus value or returning one.
				$prev = $phpcsFile->findPrevious( T_WHITESPACE, ( $stackPtr - 1 ), null, true );
				if ( T_RETURN === $tokens[ $prev ]['code'] ) {
					// Just returning a negative value; eg. return -1.
					return;
				}

				if ( in_array( $tokens[ $prev ]['code'], PHP_CodeSniffer_Tokens::$operators, true ) ) {
					// Just trying to operate on a negative value; eg. ($var * -1).
					return;
				}

				if ( in_array( $tokens[ $prev ]['code'], PHP_CodeSniffer_Tokens::$comparisonTokens, true ) ) {
					// Just trying to compare a negative value; eg. ($var === -1).
					return;
				}

				// A list of tokens that indicate that the token is not
				// part of an arithmetic operation.
				$invalidTokens = array(
					T_COMMA,
					T_OPEN_PARENTHESIS,
					T_OPEN_SQUARE_BRACKET,
				);

				if ( in_array( $tokens[ $prev ]['code'], $invalidTokens, true ) ) {
					// Just trying to use a negative value; eg. myFunction($var, -2).
					return;
				}

				$number = $phpcsFile->findNext( T_WHITESPACE, ( $stackPtr + 1 ), null, true );
				if ( T_LNUMBER === $tokens[ $number ]['code'] ) {
					$semi = $phpcsFile->findNext( T_WHITESPACE, ( $number + 1 ), null, true );
					if ( T_SEMICOLON === $tokens[ $semi ]['code'] ) {
						if ( false !== $prev && in_array( $tokens[ $prev ]['code'], PHP_CodeSniffer_Tokens::$assignmentTokens, true ) ) {
							// This is a negative assignment.
							return;
						}
					}
				}
			} // end if

			$operator = $tokens[ $stackPtr ]['content'];
		} // end if

	} // end process()

} // End class.
