/**
 *
 * Outcomes Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import { Grid } from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({});

export function Outcomes(props, context) {
  const { classes, intl } = props;

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.outcomes && props.outcomes.map((item, i) => (
          <Grid item key={item.id} xs={12}>
            {item.name}
          </Grid>
        ))}
      </Grid>
    </React.Fragment>
  );
}

Outcomes.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(Outcomes);
