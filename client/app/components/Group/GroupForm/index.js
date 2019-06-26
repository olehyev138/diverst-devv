/**
 *
 * Group Form Component
 *
 */

import React, { memo, useRef } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';

import { Field, Formik, Form } from 'formik';

export function GroupFormInner({ handleSubmit, handleChange, values }) {
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
  const form = useRef();

  return (
    <Formik
      ref={form}
      initialValues={{
        name: '',
        short_description: '',
        description: ''
      }}
      onSubmit={(values, actions) => {
        props.createGroupBegin(values);
      }}
      render={props => <GroupFormInner {...props} />}
    />
  );
}

export default compose(
  memo,
)(GroupForm);
