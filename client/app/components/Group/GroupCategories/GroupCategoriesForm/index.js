/**
 *
 * Group Categories Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import Select from 'components/Shared/DiverstSelect';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Group/messages';
import { buildValues, mapFields } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Grid, Paper, Typography,
  TextField, Hidden, FormControl, Divider, Switch, FormControlLabel,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import dig from "object-dig";

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupCategoriesFormInner({ classes, values, handleChange, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <DiverstFormLoader isLoading={props.isFormLoading}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              id='name'
              name='name'
              margin='normal'
              label='Category Name'
              value={values.name}
            />
            <Typography>Category Labels </Typography>
            <br />
            <FieldArray

              name='group_categories_attributes'
              render={arrayHelpers => (
                <div>
                  {values.group_categories_attributes && values.group_categories_attributes.length > 0 ? (
                    values.group_categories_attributes.map((category, index) => (
                      // eslint-disable-next-line react/no-array-index-key
                      <div key={index}>
                        <Field name={`group_categories_attributes.${index}.name`} />
                        <button
                          type='button'
                          onClick={() => arrayHelpers.remove(index)} // remove a friend from the list
                        >
                          -
                        </button>
                        <button
                          type='button'
                          onClick={() => arrayHelpers.insert(index, { name: '', id: '', _destroy: false })} // insert an empty string at a position
                        >
                          +
                        </button>
                      </div>
                    ))
                  ) : (
                    <button type='button' onClick={() => arrayHelpers.push({ name: '', id: '', _destroy: false })}>
                      {/* show this when user has removed all friends from the list */}
                      Add a Category
                    </button>
                  )}
                </div>
              )}
            />
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              // to={props.links.cancelLink}
              component={dig(props, 'links', 'cancelLink') ? WrappedNavLink : 'button'}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
  );
}

export function GroupCategoriesForm(props) {
  const initialValues = buildValues(props.groupCategories, {
    id: { default: '' },
    name: { default: '' },
    group_categories_attributes: { default: [] }
  });
  console.log('component');
  console.log(props);

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupCategoriesAction(mapFields(values, ['id']));
      }}
    >
      {formikProps => <GroupCategoriesFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupCategoriesForm.propTypes = {
  groupCategoriesAction: PropTypes.func,
  groupCategories: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  categories: PropTypes.array,
  currentUser: PropTypes.object,
  currentEnterprise: PropTypes.object,
};

GroupCategoriesFormInner.propTypes = {
  groupCategories: PropTypes.object,
  handleChange: PropTypes.func,
  classes: PropTypes.object,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  categories: PropTypes.array,
  getGroupCategoriesBegin: PropTypes.func,
  formikProps: PropTypes.object,
  arrayHelpers: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupCategoriesForm);
