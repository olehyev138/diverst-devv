/**
 *
 * Group Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden
} from '@material-ui/core';

import { Field, Formik, Form } from 'formik';

export function GroupFormInner(props) {
  return (
    <Card>
      <CardContent>
        <Field
          component={TextField}
          fullWidth
          label={'Name'}
        />
        <Field
          component={TextField}
          fullWidth
          label={'Summary'}
        />
        <Field
          component={TextField}
          fullWidth
          label={'Description'}
        />
      </CardContent>
      <CardActions>
        <Button type='submit'>Create</Button>
        <Button type='submit'>Cancel</Button>
      </CardActions>
    </Card>
  );
}

export function GroupForm(props) {
  return (<Formik
    render={props => <GroupFormInner {...props} /> }
  />);
}

export default compose(
  memo,
)(GroupForm);
