/**
 *
 * Group Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Grid, TextField, Hidden, FormControl
} from '@material-ui/core';
import Select from 'react-select';

import { Field, Formik, Form } from 'formik';
import { ROUTES } from 'containers/Shared/Routes/constants';

/* eslint-disable object-curly-newline */
export function GroupFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

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
            label='Short Description'
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            label='Description'
            value={values.description}
          />
          <Field
            component={Select}
            fullWidth
            id='children'
            name='children'
            label='Children'
            isMulti
            options={props.selectGroups}
            value={values.children}
            onChange={value => setFieldValue('children', value)}
            onBlur={() => setFieldTouched('children', true)}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
          <Button
            to={ROUTES.admin.manage.groups.index.path}
            component={WrappedNavLink}
          >
            Cancel
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function GroupForm(props) {
  const initialValues = {
    name: '',
    short_description: '',
    description: '',
    children: [],
  };

  return (
    <Formik
      initialValues={props.group || initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        const { children } = values;
        delete values.children;

        props.groupAction({
          ...values,
          child_ids: children.map(c => c.value),
        });
      }}
      render={formikProps => <GroupFormInner {...props} {...formikProps} />}
    />
  );
}

GroupForm.propTypes = {
  groupAction: PropTypes.func,
  group: PropTypes.object
};

GroupFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
};

export default compose(
  memo,
)(GroupForm);
