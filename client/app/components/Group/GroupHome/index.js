/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Typography } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';
import { ROUTES } from 'containers/Shared/Routes/constants';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

export function GroupHome(props) {
  return (
    <React.Fragment>
      {props.group && (
        <React.Fragment>
          <Grid container alignItems="stretch" direction="column" justify="flex-start">
            <Grid item>
              <Typography variant='h4' align='center' color='primary'>
                <span>Welcome to the </span>
                <strong>{props.group.name}</strong>
                !
              </Typography>
            </Grid>
            <Grid item>
              <DiverstImg
                data={props.group.banner_data}
                alt=''
                maxWidth='100%'
                minWidth='100%'
              />
            </Grid>
          </Grid>
        </React.Fragment>
      )}
    </React.Fragment>
  );
}

GroupHome.propTypes = {
  group: PropTypes.object,
};

export default compose(
  memo,
)(GroupHome);
