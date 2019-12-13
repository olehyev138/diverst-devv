import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

const styles = theme => ({
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

export function EventManage(props) {
  const { classes } = props;
  const event = dig(props, 'event');

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !event}>
      {event && (
        <React.Fragment>
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

EventManage.propTypes = {
  deleteEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    eventEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(EventManage);
