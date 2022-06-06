#!/usr/bin/env python
# Parameter is the CSS file
import cssutils
import sys


def selectors_count(selectors, rule):
    rules = rule.selectorText
    rules = rules.split(',')
    for rule_ in rules:
        rule_ = rule_.strip()
        if rule_ in selectors:
            selectors[rule_] += 1
        else:
            selectors[rule_] = 1

    return selectors


with open(sys.argv[1]) as f:
    style = f.readlines()

stylesheet = cssutils.parseFile(sys.argv[1])
selectors = {}

for rule in stylesheet.cssRules:
    if rule.type == cssutils.css.CSSRule.STYLE_RULE:  # Check if it is a selector
        selectors = selectors_count(selectors, rule)
    elif rule.type == cssutils.css.CSSRule.MEDIA_RULE:
        for rule_ in rule.cssRules:
            selectors = selectors_count(selectors, rule_)

selectors = sorted(selectors.items(), key=lambda x: x[1], reverse=True)
selectors = dict(selectors)
print(selectors)
