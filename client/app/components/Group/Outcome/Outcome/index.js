import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import { FormattedMessage } from 'react-intl';

const styles = theme => ({});

export function Outcome(props) {
  /* Render an Outcome */

  const { classes } = props;
  const outcome = dig(props, 'outcome');

  return (
    (outcome) ? (
      <React.Fragment>
      </React.Fragment>
    ) : <React.Fragment />
  );
}

Outcome.propTypes = {
  deleteOutcomeBegin: PropTypes.func,
  classes: PropTypes.object,
  outcome: PropTypes.object,
  currentUserId: PropTypes.number,
  links: PropTypes.shape({
    outcomeEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Outcome);
