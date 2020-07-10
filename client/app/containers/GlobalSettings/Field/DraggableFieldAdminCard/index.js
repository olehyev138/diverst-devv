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


import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Shared/Field/messages';
import { Formik } from 'formik';

import FieldForm from 'components/Shared/Fields/FieldForms/FieldForm';
import { getListDrop, getListDrag } from '../../../../utils/DragAndDropHelpers';
import Field from 'components/Shared/Fields/FieldIndexItem';


export default function DraggableFieldAdminCard({ id, text, index, moveCard, field, classes, draggable,
  deleteFieldBegin, toggles, currentEnterprise, updateFieldBegin }, props) {
  const ref = useRef(null);
  const ItemTypes = {
    CARD: 'card',
  };

  const [form, setForm] = useState(false);

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
        <Card ref={ref}>
          <CardContent>
            <Typography variant='h5' component='h2' display='inline' color='primary'>
              {field.title}
            </Typography>
          </CardContent>
          <CardActions>
            <Button
              color='primary'
              size='small'
              onClick={() => {
                setForm(!form);
              }}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
            <Button
              size='small'
              className={classes.errorButton}
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('delete?'))
                  props.deleteFieldBegin(field.id);
              }}
            >
              <DiverstFormattedMessage {...messages.delete} />
            </Button>
          </CardActions>
        </Card>
      )}
      { !draggable && (
        <Collapse in={form}>
          <FieldForm
            edit
            currentEnterprise={currentEnterprise}
            field={field}
            fieldAction={updateFieldBegin}
            cancelAction={() => setForm(false)}
            toggles={toggles}
            updateFieldBegin={updateFieldBegin}
            deleteFieldBegin={deleteFieldBegin}
          />
        </Collapse>
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
