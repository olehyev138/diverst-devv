/**
 *
 * UpdateList Component
 *
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Collapse, Box
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import Update from '../UpdateListItem';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/Update/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  updateListItem: {
    width: '100%',
  },
  updateListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  updateTitleButton: {
    textTransform: 'none',
  },
  updateFormCollapse: {
    width: '100%',
  },
  updateFormContainer: {
    width: '100%',
    padding: theme.spacing(1.5),
  },
});

export function UpdateList(props, context) {
  const { classes, ...rest } = props;

  const UPDATES = {
    text: {
      update: {
        type: 'TextUpdate',
      },
      action: props.createUpdateBegin,
    },
    check: {
      update: {
        type: 'CheckboxUpdate',
      },
      action: props.createUpdateBegin,
    },
    select: {
      update: {
        type: 'SelectUpdate',
      },
      action: props.createUpdateBegin,
    },
    date: {
      update: {
        type: 'DateUpdate',
      },
      action: props.createUpdateBegin,
    },
    number: {
      update: {
        type: 'NumericUpdate',
      },
      action: props.createUpdateBegin,
    },
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='large'
            onClick={() => {
              /* eslint-disable-next-line no-console */
              console.log('click');
            }}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.updates && Object.values(props.updates).map((update, i) => {
            return (
              <Grid item key={update.id} className={classes.updateListItem}>
                <Update
                  updateUpdateBegin={props.updateUpdateBegin}
                  deleteUpdateBegin={props.deleteUpdateBegin}
                  update={update}
                  key={update.id}
                  className={classes.eventListItem}
                  links={props.links}
                />
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={5}
        count={props.updateTotal}
        handlePagination={props.handlePagination}
      />
    </React.Fragment>
  );
}

UpdateList.propTypes = {
  classes: PropTypes.object,
  updates: PropTypes.array,
  updateTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  createUpdateBegin: PropTypes.func,
  updateUpdateBegin: PropTypes.func,
  deleteUpdateBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  isCommitting: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  currentEnterprise: PropTypes.object,

  textUpdate: PropTypes.bool,
  selectUpdate: PropTypes.bool,
  checkboxUpdate: PropTypes.bool,
  dateUpdate: PropTypes.bool,
  numberUpdate: PropTypes.bool,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(UpdateList);
