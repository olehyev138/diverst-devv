/**
 *
 *  TextField Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField, FormGroup, FormControlLabel, Switch, FormControl
} from '@material-ui/core';


import messages from 'containers/Shared/Field/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

/* Important constant for each field form - tells backend which field subclass to load */
const FIELD_TYPE = 'TextField';

/* eslint-disable object-curly-newline */
export function Toggles({ handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched, toggles, ...props }) {

  console.log(values);

  const visible = toggles.visible && (
    <FormControl
      variant='outlined'
    >
      <FormControlLabel
        labelPlacement='end'
        checked={values.private}
        control={(
          <Field
            component={Switch}
            color='primary'
            onChange={(_, value) => setFieldValue('private', value)}
            disabled={props.isCommitting}
            id={`private:${values.id}`}
            name={`private:${values.id}`}
            value={values.private}
          />
        )}
        label='Hide From User'
      />
    </FormControl>
  );

  const editable = toggles.editable && (
    <FormControl
      variant='outlined'
    >
      <FormControlLabel
        labelPlacement='end'
        checked={values.show_on_vcard}
        control={(
          <Field
            component={Switch}
            color='primary'
            onChange={(_, value) => setFieldValue('show_on_vcard', value)}
            disabled={props.isCommitting}
            id={`show_on_vcard:${values.id}`}
            name={`show_on_vcard:${values.id}`}
            value={values.show_on_vcard}
          />
        )}
        label='Allow user to edit'
      />
    </FormControl>
  );

  const required = toggles.required && (
    <FormControl
      variant='outlined'
    >
      <FormControlLabel
        labelPlacement='end'
        checked={values.required}
        control={(
          <Field
            component={Switch}
            color='primary'
            onChange={(_, value) => setFieldValue('required', value)}
            disabled={props.isCommitting}
            id={`required:${values.id}`}
            name={`required:${values.id}`}
            value={values.required}
          />
        )}
        label='Set as required'
      />
    </FormControl>
  );

  const memberList = toggles.memberList && (
    <FormControl
      variant='outlined'
    >
      <FormControlLabel
        labelPlacement='end'
        checked={values.add_to_member_list}
        control={(
          <Field
            component={Switch}
            color='primary'
            onChange={(_, value) => setFieldValue('add_to_member_list', value)}
            disabled={props.isCommitting}
            id={`add_to_member_list:${values.id}`}
            name={`add_to_member_list:${values.id}`}
            value={values.add_to_member_list}
          />
        )}
        label='Show field in Member List'
      />
    </FormControl>
  );

  return (
    <FormGroup>
      {visible}
      {editable}
      {required}
      {memberList}
    </FormGroup>
  );
}

Toggles.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  cancelAction: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
  }),
  toggles: PropTypes.shape({
    visible: PropTypes.bool,
    editable: PropTypes.bool,
    required: PropTypes.bool,
    memberList: PropTypes.bool,
  }),
};

export default compose(
  memo,
)(Toggles);
