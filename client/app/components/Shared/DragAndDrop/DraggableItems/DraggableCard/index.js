/*
 * Draggable Card component
 * A card that can be dragged around and can also be dropped on
 */

import React, { useRef, useState } from 'react';
import PropTypes from 'prop-types';

import { DndProvider, useDrag, useDrop } from 'react-dnd';


import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress, Hidden,
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

export default function DraggableCard({ id, text, index, moveCard, group, classes, draggable }, props) {
  const [expandedGroups, setExpandedGroups] = useState({});

  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && Object.keys(props.groups).length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.groups).map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

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
      // Don't replace items with themselves
      if (dragIndex === hoverIndex)
        return;

      // Determine rectangle on screen
      const hoverBoundingRect = ref.current.getBoundingClientRect();
      // Get vertical middle
      const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2;
      // Determine mouse position
      const clientOffset = monitor.getClientOffset();
      // Get pixels to the top
      const hoverClientY = clientOffset.y - hoverBoundingRect.top;

      // Only perform the move when the mouse has crossed half of the items height
      // When dragging downwards, only move when the cursor is below 50%
      // When dragging upwards, only move when the cursor is above 50%
      // Dragging downwards
      if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY)
        return;

      // Dragging upwards
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
      isDragging: monitor.isDragging(),
    }),
  });
  drag(drop(ref));

  return (
    <Grid item key={group.id} xs={12}>
      <Card
        ref={ref}
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
