/**
 *
 * Group Home Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Typography } from '@material-ui/core';
import { ROUTES } from 'containers/Shared/Routes/constants';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

export function GroupHome(props) {
  return (
    <React.Fragment>
      {
        props.group && (
          <Typography variant='h4' align='center' color='primary'>
            <span>Welcome to the </span>
            <strong>{props.group.name}</strong>
            !
          </Typography>
        )
      }
    </React.Fragment>
  );
}

GroupHome.propTypes = {
  group: PropTypes.object,
};

export default compose(
  memo,
)(GroupHome);
