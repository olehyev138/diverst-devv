/*
 * Draggable Card component
 * A draggable field admin card that can be dragged around and can also be dropped on
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
import messages from 'containers/Shared/Field/messages';
import { Formik } from 'formik';

import { ImportForm } from 'components/User/UserImport';
import { getListDrop, getListDrag } from '../../../../utils/DragAndDropHelpers';
import Field from 'components/Shared/Fields/FieldIndexItem';


export default function DraggableFieldAdminCard({ id, text, index, moveCard, field, classes, draggable, deleteFieldBegin, toggles }, props) {
  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };
  const drop = getListDrop(index, moveCard, ref);
  const drag = getListDrag(id, index, draggable);
  drag(drop(ref));

  return (
    <Grid item key={field.id} xs={12}>
      { draggable ? (
        <Card
          ref={ref}
        >
          <CardContent>
            <Typography variant='h5' component='h2' display='inline' color='primary'>
              {field.title}
            </Typography>
          </CardContent>
          <CardActions>
            <Button
              color='primary'
              size='small'
              disabled
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
            <Button
              size='small'
              className={classes.errorButton}
              disabled
            >
              <DiverstFormattedMessage {...messages.delete} />
            </Button>
          </CardActions>
        </Card>
      ) : (
        <Field
          currentEnterprise={props.currentEnterprise}
          updateFieldBegin={props.updateFieldBegin}
          deleteFieldBegin={props.deleteFieldBegin}
          field={field}
          key={field.id}
          toggles={toggles}
        />
      )}
    </Grid>
  );
}

DraggableFieldAdminCard.propTypes = {
  id: PropTypes.number,
  text: PropTypes.string,
  index: PropTypes.number,
  moveCard: PropTypes.func,
  field: PropTypes.object,
  draggable: PropTypes.bool,
  classes: PropTypes.object,
  importAction: PropTypes.func,
  deleteFieldBegin: PropTypes.func,
  updateFieldBegin: PropTypes.func,
  currentEnterprise: PropTypes.object,
  toggles: PropTypes.shape({
    visible: PropTypes.bool,
    editable: PropTypes.bool,
    required: PropTypes.bool,
    memberList: PropTypes.bool,
  }),
};
