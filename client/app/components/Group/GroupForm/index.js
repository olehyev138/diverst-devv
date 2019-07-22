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

import { mapAssociations, buildValues } from 'utils/formHelpers';

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
            value={values.name || ''}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='short_description'
            name='short_description'
            value={values.short_description || ''}
            label={<FormattedMessage {...messages.short_description} />}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            label={<FormattedMessage {...messages.description} />}
            value={values.description || ''}
          />
          <Field
            component={Select}
            fullWidth
            id='child_ids'
            name='child_ids'
            label={<FormattedMessage {...messages.children} />}
            isMulti
            value={values.child_ids}
            options={props.selectGroups}
            onMenuOpen={childrenSelectAction}
            onChange={value => setFieldValue('child_ids', value)}
            onInputChange={value => childrenSelectAction(value)}
            onBlur={() => setFieldTouched('child_ids', true)}
          />
          <Field
            component={Select}
            fullWidth
            id='parent'
            name='parent'
            label={<FormattedMessage {...messages.parent} />}
            value={values.parent || ''}
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
            to={ROUTES.admin.manage.groups.index.path()}
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
  const initialValues = buildValues(props.group, {
    name: { default: '' },
    short_description: { default: '' },
    description: { default: '' },
    parent: { default: '' },
    children: { default: [], customKey: 'child_ids' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        // let finalValues = exclude(values, 'logo_location', 'news_feed', 'banner_location');
        // finalValues = mapSelectAssociations(finalValues, ['children', 'parent'], ['child_ids', 'parent_id']);

        props.groupAction(mapAssociations(values, ['child_ids']));
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
