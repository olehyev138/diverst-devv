/**
 *
 * AdminGroupList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
  Dialog, DialogContent
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import { Formik, Form, Field } from 'formik';
import { buildValues } from 'utils/formHelpers';

import AddIcon from '@material-ui/icons/Add';
import ReorderIcon from '@material-ui/icons/Reorder';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstImg from 'components/Shared/DiverstImg';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import { DroppableList } from '../../Shared/DragAndDrop/DroppableLocations/DroppableList';

import { ImportForm } from 'components/User/UserImport';

const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
  },
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  groupCard: {
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  groupLink: {
    textTransform: 'none',
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
});

export const ItemTypes = {
  CARD: 'card',
};

export function AdminGroupList(props, context) {
  const { classes, defaultParams, intl } = props;
  const [order, setOrder] = useState(false);
  const [save, setSave] = useState(false);
  const [expandedGroups, setExpandedGroups] = useState({});
  const [importGroup, setImportGroup] = useState(0);
  const handleDialogClose = () => setImportGroup(0);
  const handleDialogOpen = id => setImportGroup(id);

  const importDialog = (
    <Dialog
      open={importGroup}
      onClose={handleDialogClose}
      aria-labelledby='alert-dialog-slide-title'
      aria-describedby='alert-dialog-slide-description'
    >
      <DialogContent>
        <Typography component='h2' variant='h6' className={classes.dataHeaders}>
          Import instructions
        </Typography>
        <Typography component='h2' variant='body1' color='secondary' className={classes.data}>
          {'To batch import users to this group, upload a CSV file using the form below. The file should only contain a single column comprised of the users\' email adresses. The first row will be ignored, as it is reserved for the header.'}
        </Typography>
      </DialogContent>
      <Formik
        initialValues={{
          group_id: importGroup,
          import_file: null
        }}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.importAction(values);
          handleDialogClose();
        }}
      >
        {formikProps => <ImportForm {...props} {...formikProps} />}
      </Formik>
    </Dialog>
  );


  return (
    <React.Fragment>
      { importDialog }
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.new.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
          { order ? (
            <Button
              variant='contained'
              color='primary'
              size='large'
              startIcon={<ReorderIcon />}
              onClick={() => {
                setSave(true);
              }
              }
            >
              <DiverstFormattedMessage {...messages.set_order} />
            </Button>
          ) : (
            <Button
              variant='contained'
              color='primary'
              size='large'
              startIcon={<ReorderIcon />}
              onClick={() => { setOrder(true); }}
            >
              <DiverstFormattedMessage {...messages.change_order} />
            </Button>
          )

          }

        </Grid>
      </Grid>
      <Box mb={1} />
      <DiverstLoader isLoading={props.isLoading}>
        <DroppableList
          list={props.groups}
          classes={classes}
          draggable={order}
          save={save}
          updateGroupPositionBegin={props.updateGroupPositionBegin}
          currentPage={defaultParams.page}
        />
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        handlePagination={props.handlePagination}
        rowsPerPage={defaultParams.count}
        count={props.groupTotal}
      />
    </React.Fragment>
  );
}

AdminGroupList.propTypes = {
  intl: intlShape,
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  updateGroupPositionBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  importAction: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(AdminGroupList);
