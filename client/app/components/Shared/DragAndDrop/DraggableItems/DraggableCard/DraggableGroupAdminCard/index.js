/*
 * Draggable Card component
 * A card that can be dragged around and can also be dropped on
 */

import React, { useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';

import { useDrag, useDrop } from 'react-dnd';

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

export default function DraggableGroupAdminCard({ id, text, index, moveCard, group, classes, draggable }, props) {
  const { intl } = props;
  const [expandedGroups, setExpandedGroups] = useState({});

  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };

  const [, drop] = useDrop({
    accept: ItemTypes.CARD,
    hover(item, monitor) {
      if (!ref.current)
        return;

      const dragIndex = item.index;
      const hoverIndex = index;

      if (dragIndex === hoverIndex)
        return;

      const hoverBoundingRect = ref.current.getBoundingClientRect();
      const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
      const clientOffset = monitor.getClientOffset();
      const hoverClientY = clientOffset.y - hoverBoundingRect.top;

      if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY)
        return;

      if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY)
        return;

      moveCard(dragIndex, hoverIndex);
      item.index = hoverIndex;
    },
  });

  const [{ isDragging }, drag] = useDrag({
    item: { type: ItemTypes.CARD, id, index },
    canDrag: draggable,
    collect: monitor => ({
      isDragging: monitor.isDragging()
    })
  });
  drag(drop(ref));

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
    <Grid item key={group.id} xs={12}>
      { importDialog }
      { draggable ? (
        <Card
          ref={ref}
          className={classes.draggableCard}
        >
          <CardContent>
            <Grid container spacing={2} alignItems='center'>
              {group.logo_data && (
                <React.Fragment>
                  <Hidden xsDown>
                    <Grid item xs='auto'>
                      <DiverstImg
                        data={group.logo_data}
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
          <Permission show={permission(group, 'update?')}>
            <CardActions>
              <Button
                size='small'
                color='primary'
                to={{
                  pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/edit`,
                  state: { id: group.id }
                }}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
              <Permission show={permission(group, 'destroy?')}>
                <Button
                  size='small'
                  className={classes.errorButton}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm(intl.formatMessage(messages.delete_confirm)))
                      props.deleteGroupBegin(group.id);
                  }}
                >
                  <DiverstFormattedMessage {...messages.delete} />
                </Button>
              </Permission>
              <Button
                size='small'
                onClick={() => {
                  setExpandedGroups({ ...expandedGroups, [group.id]: !expandedGroups[group.id] });
                }}
              >
                {expandedGroups[group.id] ? (
                  <DiverstFormattedMessage {...messages.children_collapse} />
                ) : (
                  <DiverstFormattedMessage {...messages.children_expand} />
                )}
              </Button>
              <Button
                size='small'
                color='primary'
                onClick={() => handleDialogOpen(group.id)}
              >
                Import Users
              </Button>
              <Button
                size='small'
                color='primary'
                to={{
                  pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/categorize`,
                  state: { id: group.id }
                }}
                component={WrappedNavLink}
              >
                Categorize Subgroups
              </Button>
            </CardActions>
          </Permission>
        </Card>

      ) : (
        <Card
          ref={ref}
          className={classes.groupCard}
        >
          <CardContent>
            <Grid container spacing={2} alignItems='center'>
              {group.logo_data && (
                <React.Fragment>
                  <Hidden xsDown>
                    <Grid item xs='auto'>
                      <DiverstImg
                        data={group.logo_data}
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
          <Permission show={permission(group, 'update?')}>
            <CardActions>
              <Button
                size='small'
                color='primary'
                to={{
                  pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/edit`,
                  state: { id: group.id }
                }}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
              <Permission show={permission(group, 'destroy?')}>
                <Button
                  size='small'
                  className={classes.errorButton}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm(intl.formatMessage(messages.delete_confirm)))
                      props.deleteGroupBegin(group.id);
                  }}
                >
                  <DiverstFormattedMessage {...messages.delete} />
                </Button>
              </Permission>
              <Button
                size='small'
                onClick={() => {
                  setExpandedGroups({ ...expandedGroups, [group.id]: !expandedGroups[group.id] });
                }}
              >
                {expandedGroups[group.id] ? (
                  <DiverstFormattedMessage {...messages.children_collapse} />
                ) : (
                  <DiverstFormattedMessage {...messages.children_expand} />
                )}
              </Button>
              <Button
                size='small'
                color='primary'
                onClick={() => handleDialogOpen(group.id)}
              >
                Import Users
              </Button>
              <Button
                size='small'
                color='primary'
                to={{
                  pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/categorize`,
                  state: { id: group.id }
                }}
                component={WrappedNavLink}
              >
                Categorize Subgroups
              </Button>
            </CardActions>
          </Permission>
        </Card>
      )}
      <Collapse in={expandedGroups[`${group.id}`]}>
        <Box mt={1} />
        <Grid container spacing={2} justify='flex-end'>
          {group.children && group.children.map((childGroup, i) => (
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
                  <Button
                    size='small'
                    color='primary'
                    onClick={() => handleDialogOpen(childGroup.id)}
                  >
                    Import Users
                  </Button>
                  <Button
                    size='small'
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete group?'))
                        props.deleteGroupBegin(childGroup.id);
                    }}
                  >
                    <DiverstFormattedMessage {...messages.delete} />
                  </Button>
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
  intl: intlShape,
};
