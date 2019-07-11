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
  Button, Card, CardActions, CardContent, Grid,
  TextField, Hidden, FormControl
} from '@material-ui/core';
import Select from 'react-select';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';

import { mapSelectAssociations } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function GroupFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const childrenSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
      query_scopes: ['all_parents', 'no_children']
    });
  };

  const parentSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      query_scopes: ['all_parents']
    });
  };

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
            label={<FormattedMessage {...messages.name} />}
            value={values.name}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='short_description'
            name='short_description'
            value={values.short_description}
            label={<FormattedMessage {...messages.short_description} />}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            label={<FormattedMessage {...messages.description} />}
            value={values.description}
          />
          <Field
            component={Select}
            fullWidth
            id='children'
            name='children'
            label={<FormattedMessage {...messages.children} />}
            isMulti
            value={values.children}
            options={props.selectGroups}
            onMenuOpen={childrenSelectAction}
            onChange={value => setFieldValue('children', value)}
            onInputChange={value => childrenSelectAction(value)}
            onBlur={() => setFieldTouched('children', true)}
          />
          <Field
            component={Select}
            fullWidth
            id='parent'
            name='parent'
            label={<FormattedMessage {...messages.parent} />}
            value={values.parent}
            options={props.selectGroups}
            onMenuOpen={parentSelectAction}
            onChange={value => setFieldValue('parent', value)}
            onInputChange={value => parentSelectAction(value)}
            onBlur={() => setFieldTouched('parent', true)}
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
            <FormattedMessage {...messages.cancel} />
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
        props.groupAction(mapSelectAssociations(values,
          ['children', 'parent'], ['child_ids', 'parent_id']));
      }}

      render={formikProps => <GroupFormInner {...props} {...formikProps} />}
    />
  );
}

GroupForm.propTypes = {
  groupAction: PropTypes.func,
  group: PropTypes.object,
};

GroupFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func
};

export default compose(
  memo,
)(GroupForm);
