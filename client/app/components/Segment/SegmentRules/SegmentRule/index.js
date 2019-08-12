/**
 *
 * Segment Rule
 *
 * - Acts as the 'super' component
 * - Given a segment rule type and renders the appropriate field input
 *
 * - We use Formiks 'connect' function to hook into Formik's context
 * - This way we can build our own custom Formik fields
 */

import React from 'react';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import SegmentOrderRule from 'components/Segment/SegmentRules/SegmentOrderRule';

const SegmentRule = (props) => {
  const ruleName = dig(props, 'ruleName');

  const renderRule = (ruleName) => {
    switch (ruleName) {
      case 'order_rules_attributes':
        return (<SegmentOrderRule {...props} />);
      default:
        return (<React.Fragment />);
    }
  };

  return renderRule(ruleName);
};

SegmentRule.propTypes = {
  ruleName: PropTypes.string
};

export default SegmentRule;
