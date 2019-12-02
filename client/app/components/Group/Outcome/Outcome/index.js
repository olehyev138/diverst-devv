import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Typography, Grid
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
});

export function Outcome(props) {
  const { classes } = props;
  const outcome = dig(props, 'outcome');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !outcome}>
      {outcome && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {outcome.name}
              </Typography>
            </Grid>
          </Grid>
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

Outcome.propTypes = {
  classes: PropTypes.object,
  outcome: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    outcomeEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Outcome);
