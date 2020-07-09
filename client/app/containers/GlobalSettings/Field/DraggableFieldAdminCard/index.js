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


export default function DraggableFieldAdminCard({ id, text, index, moveCard, field, classes, draggable, deleteFieldBegin }, props) {
  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };
  const drop = getListDrop(index, moveCard, ref);
  const drag = getListDrag(id, index, draggable);
  drag(drop(ref));
console.log(field);
  return (
    <Grid item key={field.id} xs={12}>
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
};
