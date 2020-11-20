/*
 * Draggable Card component
 * A draggable group admin card that can be dragged around and can also be dropped on
 */

import React, { useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden, Dialog, DialogContent,
} from '@material-ui/core';

import DiverstImg from 'components/Shared/DiverstImg';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import { Formik } from 'formik';

import { ImportForm } from 'components/User/UserImport';
import { intlShape } from 'react-intl';
import { getListDrop, getListDrag } from 'utils/DragAndDropHelpers';


export default function DraggableGroupAdminCard({ id, text, index, moveCard, group, classes, draggable, intl, deleteGroupBegin }, props) {
  const [expandedGroups, setExpandedGroups] = useState({});
  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };
  const drop = getListDrop(index, moveCard, ref);
  const drag = getListDrag(id, index, draggable);
  drag(drop(ref));

  const [importGroup, setImportGroup] = useState(0);
  const handleDialogClose = () => setImportGroup(0);
  const handleDialogOpen = id => setImportGroup(id);

  const children = (group.children ? group.children : []);

  const cardContent = (
    <CardContent>
      <Grid container spacing={2} alignItems='center'>
        {group.logo_data && (
          <React.Fragment>
            <Hidden xsDown>
              <Grid item xs='auto'>
                <DiverstImg
                  data={group.logo_data}
                  contentType={group.logo_content_type}
                  maxWidth='70px'
                  maxHeight='70px'
                  minWidth='70px'
                  minHeight='70px'
                />
              </Grid>
            </Hidden>
          </React.Fragment>
        )}
        <Grid item xs>
          <Button
            className={classes.groupLink}
            color='primary'
            component={WrappedNavLink}
            to={{
              pathname: ROUTES.group.home.path(group.id),
              state: { id: group.id }
            }}
          >
            <Typography variant='h5' component='h2' display='inline'>
              {group.name}
            </Typography>
          </Button>
          {group.short_description && (
            <Typography color='textSecondary' className={classes.groupListItemDescription}>
              &ensp;
              {group.short_description}
            </Typography>
          )}
        </Grid>
      </Grid>
    </CardContent>
  );

  const cardActions = (
    <CardActions>
      <Permission show={permission(group, 'update?')}>
        <Button
          size='small'
          color='primary'
          to={{
            pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/edit`,
            state: { id: group.id }
          }}
          component={WrappedNavLink}
          disabled={draggable}
        >
          <DiverstFormattedMessage {...messages.edit} />
        </Button>
      </Permission>
      <Permission show={permission(group, 'destroy?')}>
        <Button
          size='small'
          className={classes.errorButton}
          onClick={() => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm(intl.formatMessage(messages.delete_confirm)))
              deleteGroupBegin(group.id);
          }}
          disabled={draggable}
        >
          <DiverstFormattedMessage {...messages.delete} />
        </Button>
      </Permission>
      {children.length > 0 && (
        <React.Fragment>
          <Button
            size='small'
            onClick={() => {
              setExpandedGroups({ ...expandedGroups, [group.id]: !expandedGroups[group.id] });
            }}
            disabled={draggable}
          >
            {expandedGroups[group.id] ? (
              <DiverstFormattedMessage {...messages.children_collapse} />
            ) : (
              <DiverstFormattedMessage {...messages.children_expand} />
            )}

          </Button>
          <Permission show={permission(group, 'update?')}>
            <Button
              size='small'
              color='primary'
              to={{
                pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/categorize`,
                state: { id: group.id }
              }}
              component={WrappedNavLink}
              disabled={draggable}
            >
              <DiverstFormattedMessage {...messages.categorizeCollapsable} />
            </Button>
          </Permission>

          <Permission show={permission(group, 'update?')}>
            <Button
              size='small'
              color='primary'
              to={ROUTES.admin.manage.groups.regions.index.path(group.id)}
              component={WrappedNavLink}
              disabled={draggable}
            >
              <DiverstFormattedMessage {...messages.manage_regions} />
            </Button>
          </Permission>
        </React.Fragment>
      )}
      <Permission show={permission(group, 'add_members?')}>
        <Button
          size='small'
          color='primary'
          onClick={() => handleDialogOpen(group.id)}
        >
          Import Users
        </Button>
      </Permission>
    </CardActions>
  );

  const importDialog = (
    <Dialog
      open={importGroup !== 0}
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

  // If a group has the sub-groups list open ensure the open state is wiped
  if (draggable && (Object.entries(expandedGroups).length !== 0))
    setExpandedGroups({});


  return (
    <Grid item key={group.id} xs={12}>
      { importDialog }
      <Card
        ref={ref}
        className={draggable ? classes.draggableCard : classes.groupCard}
      >
        {cardContent}
        {cardActions}
      </Card>
      <Collapse in={!draggable && expandedGroups[`${group.id}`]}>
        <Box mt={1} />
        <Grid container spacing={2} justify='flex-end'>
          {children && children.map((childGroup, i) => (
            /* eslint-disable-next-line react/jsx-wrap-multilines */
            <Grid item key={childGroup.id} xs={12}>
              <Card className={classes.childGroupCard}>
                <CardContent>
                  <Grid container spacing={2} alignItems='center'>
                    {childGroup.logo_data && (
                      <React.Fragment>
                        <Hidden xsDown>
                          <Grid item xs='auto'>
                            <DiverstImg
                              data={childGroup.logo_data}
                              contentType={childGroup.logo_content_type}
                              maxWidth='60px'
                              maxHeight='60px'
                              minWidth='60px'
                              minHeight='60px'
                            />
                          </Grid>
                        </Hidden>
                      </React.Fragment>
                    )}
                    <Grid item xs>
                      <Link
                        component={WrappedNavLink}
                        to={{
                          pathname: ROUTES.group.home.path(childGroup.id),
                          state: { id: childGroup.id }
                        }}
                      >
                        <Typography variant='h5' component='h2' display='inline'>
                          {childGroup.name}
                        </Typography>
                      </Link>
                      {childGroup.short_description && (
                        <Typography color='textSecondary' className={classes.groupListItemDescription}>
                          {childGroup.short_description}
                        </Typography>
                      )}
                    </Grid>
                  </Grid>
                </CardContent>
                <CardActions>
                  <Permission show={permission(childGroup, 'update?')}>
                    <Button
                      size='small'
                      color='primary'
                      to={{
                        pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${childGroup.id}/edit`,
                        state: { id: childGroup.id }
                      }}
                      component={WrappedNavLink}
                    >
                      <DiverstFormattedMessage {...messages.edit} />
                    </Button>
                  </Permission>
                  <Permission show={permission(childGroup, 'add_members?')}>
                    <Button
                      size='small'
                      color='primary'
                      onClick={() => handleDialogOpen(childGroup.id)}
                    >
                    Import Users
                    </Button>
                  </Permission>
                  <Permission show={permission(childGroup, 'destroy?')}>
                    <Button
                      size='small'
                      className={classes.errorButton}
                      onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                        if (confirm('Delete group?'))
                          deleteGroupBegin(childGroup.id);
                      }}
                    >
                      <DiverstFormattedMessage {...messages.delete} />
                    </Button>
                  </Permission>
                </CardActions>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Collapse>
    </Grid>
  );
}

DraggableGroupAdminCard.propTypes = {
  id: PropTypes.number,
  text: PropTypes.string,
  index: PropTypes.number,
  moveCard: PropTypes.func,
  group: PropTypes.object,
  draggable: PropTypes.bool,
  classes: PropTypes.object,
  importAction: PropTypes.func,
  deleteGroupBegin: PropTypes.func,
  intl: intlShape.isRequired,
};
