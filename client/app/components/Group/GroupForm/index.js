/**
 *
 * Group Form Component
 *
 */

import React, { memo, useRef, useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';

import { Field, Formik, Form } from 'formik';

export function GroupFormInner({ handleSubmit, handleChange, handleBlur, values }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='name'
            name='name'
            label='Name'
            value={values.name}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='short_description'
            name='short_description'
            label={'Short Description'}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            label={'Description'}
            value={values.description}
          />
        </CardContent>
        <CardActions>
          <Button type='submit'>Create</Button>
          <Button>Cancel</Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupForm(props) {
  const initialValues = {
    name: '',
    short_description: '',
    description: ''
  };

  return (
    <Formik
      initialValues={props.group || initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupAction(values);
      }}
      render={props => <GroupFormInner {...props} />}
    />
  );
}

GroupForm.propTypes = {
  groupAction: PropTypes.func
};

export default compose(
  memo,
)(GroupForm);
