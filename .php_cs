<?php
$finder = PhpCsFixer\Finder::create()
    ->exclude('vendor')
    ->in(__DIR__)
;

return PhpCsFixer\Config::create()
    ->setRules([
        // '@Symfony' => true,
        'concat_space' => [
            'spacing' => 'none',
        ],
        'single_blank_line_before_namespace' => true,
        'blank_line_after_namespace' => true,
        'single_line_after_imports' => true,
        'no_trailing_whitespace' => true,
        'no_unused_imports' => true,
        'no_whitespace_before_comma_in_array' => true,
        'no_whitespace_in_blank_line' => true,
        'object_operator_without_whitespace' => true,
        'not_operator_with_space' => true,
        'ordered_imports' => true,
        'ternary_operator_spaces' => true,
        'ternary_to_null_coalescing' => true,
        'trailing_comma_in_multiline_array' => true,
        'unary_operator_spaces'             => true,
        'whitespace_after_comma_in_array'   => true,
        'switch_case_space' => true,
        'single_quote' => true,
        'binary_operator_spaces' => [
            'default'   => 'align_single_space',
            'operators' => [
            ],
        ],
        // 'blank_line_before_statement' => [
            // 'statements'=>[
                // 'if',
                // 'return',
            // ]
        // ],
    ])
;
